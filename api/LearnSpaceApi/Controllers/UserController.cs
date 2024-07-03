using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Runtime.Remoting.Messaging;
using System.Web;
using System.Web.Http;
using LearnSpaceApi.Models;
using System.IO;
using System.Security.Cryptography;

namespace LearnSpaceApi.Controllers
{
    public class UserController : ApiController
    {
        slowlearnerDataBaseEntities db = new slowlearnerDataBaseEntities();
        public HttpResponseMessage GetAllTestResults(int pid)
        {
            try
            {
                var groupedData = db.Appointments
                 .Where(e => e.patientId == pid)
                 .Join(db.PatientTestCollectionFeedbacks, appintment => appintment.id, ptcf => ptcf.AppointmentId, (appoint, ptcf) => new
                 {
                     appoint.appointmentDate,
                     ptcf.AppointmentId,
                     ptcf.feedback,
                 })// Filter by patientId
                 .GroupBy(e => e.AppointmentId)        // Group by appointId
                 .Select(group => new
                 {
                     AppointId = group.Key,
                     Feedbacks = group.Select(e => new
                     {
                         e.feedback,
                         e.AppointmentId,
                         e.appointmentDate
                     })
                 })
                 .ToList();
                List<AllTestDatas> allTestDatacs = new List<AllTestDatas>();
                foreach (var group in groupedData)
                {
                    AllTestDatas testData = new AllTestDatas();
                    float count = 0;
                    int length = group.Feedbacks.Count();
                    foreach (var data in group.Feedbacks)
                    {
                        testData.name = data.appointmentDate.ToShortDateString();


                        if (data.feedback == true)
                        {
                            count++;
                        }
                    }

                    testData.Total = (count / length) * 100;
                    allTestDatacs.Add(testData);
                }
                return Request.CreateResponse(HttpStatusCode.OK, allTestDatacs);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.NotFound, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage specificTestResults(int pid,int did)
        {
            try
            {
                var prevDate = db.Appointments.Where(e=>e.patientId==pid&&e.userId==did).OrderByDescending(e=>e.appointmentDate).FirstOrDefault();
                if (prevDate == null) 
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound,"No previous appointment found.");
                }
                var groupedData = db.Appointments
                 .Where(e => e.patientId == pid&&e.appointmentDate>=prevDate.appointmentDate)
                 .Join(db.PatientTestCollectionFeedbacks, appintment => appintment.id, ptcf => ptcf.AppointmentId, (appoint, ptcf) => new
                 {
                     appoint.appointmentDate,
                     ptcf.AppointmentId,
                     ptcf.feedback,
                 })// Filter by patientId
                 .GroupBy(e => e.AppointmentId)        // Group by appointId
                 .Select(group => new
                 {
                     AppointId = group.Key,
                     Feedbacks = group.Select(e => new
                     {
                         e.feedback,
                         e.AppointmentId,
                         e.appointmentDate
                     })
                 })
                 .ToList();
                List<AllTestDatas> allTestDatacs = new List<AllTestDatas>();
                foreach (var group in groupedData)
                {
                    AllTestDatas testData = new AllTestDatas();
                    float count = 0;
                    int length = group.Feedbacks.Count();
                    foreach (var data in group.Feedbacks)
                    {
                        testData.name = data.appointmentDate.ToShortDateString();


                        if (data.feedback == true)
                        {
                            count++;
                        }
                    }

                    testData.Total = (count / length) * 100;
                    allTestDatacs.Add(testData);
                }
                return Request.CreateResponse(HttpStatusCode.OK, allTestDatacs);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.NotFound, ex.Message);
            }
        }

        [HttpGet]
        public HttpResponseMessage deleteAppdata(int appid)
        {
            var data = db.Appointments.Where(e => e.id == appid).FirstOrDefault();
            db.Appointments.Remove(data);
            db.SaveChanges();
            return Request.CreateResponse(HttpStatusCode.OK, "deleted");
        }
        [HttpGet]
        public HttpResponseMessage AssignedPractice(int Pid, DateTime date)
        {
            try
            {
                DateTime startDate = date.Date;
                DateTime endDate = startDate.AddDays(1);
                //var data = db.Appointments.Where(e => e.patientId == Pid && e.nextAppointDate >= startDate && e.nextAppointDate < endDate).ToList();
                var PracticeData = db.Appointments.Where(e => e.appointmentDate >= startDate  && e.patientId == Pid)
                    .Join(db.AppointmentPractices, appoint => appoint.id, appoimtPrac => appoimtPrac.appointmentId, (appoint, appointmentPractic) => new { appoint, appointmentPractic })
                    .Join(db.PracticeCollections, AppointmentPractic => AppointmentPractic.appointmentPractic.practiceId, practicecollection => practicecollection.pracId, (appoint, pracCollection) => new { appoint, pracCollection })
                    .Join(db.Collections, ptcf => ptcf.pracCollection.collectId, collect => collect.id, (all, collect) => new
                    {
                        AppointmentDate = all.appoint.appoint.appointmentDate,
                        practiceCollectionId = all.pracCollection.id,
                        
                        picPath = collect.picPath,
                        eText = collect.eText,
                        uText = collect.uText,
                        C_group = collect.C_group,
                        type = collect.type,
                        id = collect.id,
                        audioPath =collect.audioPath,
                        title=db.Practices.Where(e=>e.id== all.pracCollection.pracId).Select(e=>e.title).FirstOrDefault(),
                        all.pracCollection.pracId,
                        appointmentId=all.appoint.appoint.id,
                        /*picPath = Convert.ToBase64String(File.ReadAllBytes(collect.picPath)),
                        audioPath= Convert.ToBase64String(File.ReadAllBytes(collect.audioPath))*/
                    }).GroupBy(e => e.AppointmentDate)
                .OrderByDescending(group => group.Key)
                .Select(group => new
                {
                    Appointment = group.Key,
                    Collections = group.Select(e => new
                    {

                        e.title,
                        e.pracId,
                        e.appointmentId,
                        e.AppointmentDate,
                        e.practiceCollectionId,
                        e.id,
                        e.picPath,
                        e.eText,
                        e.uText,
                        e.C_group,
                        e.type,
                        e.audioPath
                    }).OrderBy(c => c.AppointmentDate).ToList() // Order collections within each appointment
                });
                List<PatientPracticeData> ppd = new List<PatientPracticeData>();
                foreach(var u in PracticeData) 
                {
                   foreach(var person in u.Collections) 
                    {
                        PatientPracticeData pd =new PatientPracticeData();
                        pd.uText = person.uText;
                        pd.eText = person.eText;
                        pd.AppointmentDate = person.AppointmentDate;
                        pd.appointmentId = person.appointmentId;
                        pd.C_group = person.C_group;
                        pd.title = person.title;
                        pd.id = person.id;
                        pd.picPath = Convert.ToBase64String(File.ReadAllBytes(person.picPath));
                        pd.audioPath = Convert.ToBase64String(File.ReadAllBytes(person.audioPath));
                        pd.pracId = person.pracId;
                        pd.practiceCollectionId = person.practiceCollectionId;
                        pd.type = person.type;
                        ppd.Add(pd);
                    }
                }
               /* var x = new
                {
                    Appointment = date,
                    Collections = ppd
                };*/
                return Request.CreateResponse(HttpStatusCode.OK, ppd);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message + ex.InnerException);
            }

        }
        [HttpPost]
        public HttpResponseMessage addAppointment(PatientAppointment pa)
        {
            try
            {
                bool appointmentCreated = false;
                if (pa.appointmentPractices != null && pa.appointmentPractices.Count != 0)
                {
                    //check if practice is already currently assigned
                    foreach (var item in pa.appointmentPractices)
                    {
                        var duplication = db.AppointmentPractices.Where(e => e.practiceId == item.practiceId).Join(db.Appointments, ap => ap.appointmentId, appointments => appointments.id, (ap, appointments) => new { appointments.nextAppointDate }).ToList();
                        if (duplication.Any())
                        {
                            foreach (var v in duplication)
                            {
                                int compareDate = DateTime.Compare(v.nextAppointDate, DateTime.Now);
                                //next appointment date is greater than current date or if it is same day
                                if (compareDate > 0 || compareDate == 0)
                                {
                                    Practice pr = db.Practices.Where(ex => ex.id == item.practiceId).FirstOrDefault();
                                    return Request.CreateResponse(HttpStatusCode.Conflict, pr.title + " is already assigned");
                                }
                            }
                        }
                    }
                    db.Appointments.Add(pa.appointment);
                    db.SaveChanges();
                    appointmentCreated = true;
                    foreach (var item in pa.appointmentPractices)
                    {
                        item.appointmentId = pa.appointment.id;
                        //changing assignedFlag
                        var PracticeFlagToUpdate = db.Practices.FirstOrDefault(p => p.id == item.practiceId);
                        if (PracticeFlagToUpdate != null)
                        {
                            PracticeFlagToUpdate.assignedFlag = 1;
                        }
                    }
                    db.AppointmentPractices.AddRange(pa.appointmentPractices);

                }
                if (pa.appointmentTests != null && pa.appointmentTests.Count != 0)
                {
                    foreach (var item in pa.appointmentTests)
                    {
                        var duplication = db.AppointmentTests.Where(e => e.testId == item.testId).Join(db.Appointments, ap => ap.appointmentId, appointments => appointments.id, (ap, appointments) => new { appointments.nextAppointDate }).ToList();
                        if (duplication.Any())
                        {
                            foreach (var v in duplication)
                            {
                                int compareDate = DateTime.Compare(v.nextAppointDate, DateTime.Now);
                                //next appointment date is greater than current date or if it is same day
                                if (compareDate > 0 || compareDate == 0)
                                {
                                    Test pr = db.Tests.Where(ex => ex.id == item.testId).FirstOrDefault();
                                    return Request.CreateResponse(HttpStatusCode.Conflict, pr.title + " is already assigned");
                                }
                            }
                        }
                    }
                    if (!appointmentCreated)
                    {
                        db.Appointments.Add(pa.appointment);
                        db.SaveChanges();
                        appointmentCreated = true;
                    }
                    foreach (var item in pa.appointmentTests)
                    {
                        item.appointmentId = pa.appointment.id;
                    }
                    db.AppointmentTests.AddRange(pa.appointmentTests);
                }
                if (pa.AppointmentPersonPractice != null)
                {
                    if (!appointmentCreated)
                    {
                        db.Appointments.Add(pa.appointment);
                        db.SaveChanges();
                        appointmentCreated = true;
                    }
                    foreach (var item in pa.AppointmentPersonPractice)
                    {
                        item.appointmentId = pa.appointment.id;
                    }
                    db.AppointmentPersonPractices.AddRange(pa.AppointmentPersonPractice);
                }
                if (pa.AppointmentPersonTest != null)
                {
                    if (!appointmentCreated)
                    {
                        db.Appointments.Add(pa.appointment);
                        db.SaveChanges();
                    }
                    foreach (var item in pa.AppointmentPersonTest)
                    {
                        item.appointmentId = pa.appointment.id;
                    }
                    db.AppointmentPersonTests.AddRange(pa.AppointmentPersonTest);
                }

                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Appointment added successfully");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError,ex.Message + ex.InnerException);
            }
        }
        [HttpGet]
        public HttpResponseMessage checkPatientAgainstCaregiver(int cgId)
        {
            var data = db.UserPatients.Where(c => c.userId == cgId).FirstOrDefault();
            if (data == null)
            {
                return Request.CreateResponse(HttpStatusCode.NotFound, "Does not exist.");
            }
            var patient = db.Patients.FirstOrDefault(p => p.pid == data.patientId);
            byte[] imageBytes = File.ReadAllBytes(patient.profPicPath);
            patient.profPicPath = Convert.ToBase64String(imageBytes);
            return Request.CreateResponse(HttpStatusCode.OK, patient);
        }
        [HttpGet]
        public HttpResponseMessage patientAgainstUsername(string p)
        {
            var data = db.Patients.Where(c => c.userName == p).FirstOrDefault();
            if (data == null)
            {
                return Request.CreateResponse(HttpStatusCode.NotFound, "Does not exist.");
            }
            return Request.CreateResponse(HttpStatusCode.OK, data.pid);
        }
        [HttpGet]
        public HttpResponseMessage checkCaregiverAgainstPatient(int pId)
        {
            var data = db.UserPatients.Where(c => c.patientId == pId).FirstOrDefault();
            if (data == null)
            {
                return Request.CreateResponse(HttpStatusCode.NotFound, "Does not exist.");
            }
            return Request.CreateResponse(HttpStatusCode.OK, data.userId);
        }
        [HttpPost]
        public HttpResponseMessage SignUp()
        {
            var request = HttpContext.Current.Request;
            var name = request["name"];
            var type = request["type"];
            var username = request["username"];
            var password = request["password"];
            var profilePic = request.Files["profilePic"];

            var validation = db.Users.Where(e => e.username == username).ToList();
            if (validation.Any())
            {
                return Request.CreateResponse(HttpStatusCode.Conflict, "username Already exist use another username");
            }
            string fileName = username.Split('@')[0] + "." + profilePic.FileName.Split('.')[1];
            profilePic.SaveAs("C:\\Users\\us\\source\\LearnSpaceApi\\LearnSpaceApi\\Media\\UserImages\\" + fileName);
            User user = new User();
            user.username = username;
            user.password = password;
            user.type = type;
            user.name = name;
            user.profPicPath = "Media\\UserImages\\" + fileName;
            db.Users.Add(user);
            db.SaveChanges();
            return Request.CreateResponse(HttpStatusCode.OK, "registerd");
        }


        [HttpGet]
        public HttpResponseMessage SignIn(string username, string password, string type)
        {
            try
            {
                var data = db.Users.Where(e => e.username == username && e.password == password && e.type == type).Select(user => new { user.uid, user.type, user.profPicPath, user.name, user.username, user.password }).FirstOrDefault();
                if (data == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NonAuthoritativeInformation, "invalid Username Or Password");
                }
                User u = new Models.User();
                u.uid = data.uid;
                u.password = data.password;
                u.username = data.username;
                u.type = data.type;
               // u.profPicPath = "C:\\Users\\us\\source\\LearnSpaceApi\\LearnSpaceApi\\" + data.profPicPath;
               u.profPicPath = data.profPicPath;
                u.name = data.name;
              //  byte[] imageBytes = File.ReadAllBytes(u.profPicPath);
              //  u.profPicPath = Convert.ToBase64String(imageBytes);
                return Request.CreateResponse(HttpStatusCode.OK, u);
            }catch(Exception ex) 
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "Whoops"+ex.Message+ex.InnerException);
            }
            
        }
        [HttpGet]
        public HttpResponseMessage AssignedTest(int Pid, string filter)
        {
            var data = db.Patients
             .Where(e => e.pid == Pid)
             .Join(db.Appointments, p => p.pid, ap => ap.patientId, (patien, appoint) => new { patien, appoint })
             .Join(db.AppointmentTests, p => p.appoint.id, c => c.appointmentId, (appointment, appointTest) => new { appointment, appointTest })
             .Join(db.TestCollections, ap => ap.appointTest.testId, tc => tc.testId, (app, testcollect) => new { app, testcollect })
             .Join(db.Collections, test => test.testcollect.collectId, c => c.id, (testCollect, collect) => new
             {
                 AppointmentDate = testCollect.app.appointment.appoint.appointmentDate,
                 AppointmentId = testCollect.app.appointment.appoint.id,
                 testCollectionID = testCollect.testcollect.id,
                 CollectId = collect.id,
                 Path = collect.picPath,
                 Etext = collect.eText,
                 Utext = collect.uText,
                 Group = collect.C_group,
                 TestId = testCollect.app.appointTest.testId,
                 Type = collect.type,
                 collectAudio = collect.audioPath,
                 Opt1 = testCollect.testcollect.op1,
                 Opt2 = testCollect.testcollect.op2,
                 Opt3 = testCollect.testcollect.op3,
                 Opt1eText = db.Collections.Where(c => c.id == testCollect.testcollect.op1).Select(c => c.eText).FirstOrDefault(),
                 Opt2eText = db.Collections.Where(c => c.id == testCollect.testcollect.op2).Select(c => c.eText).FirstOrDefault(),
                 Opt3eText = db.Collections.Where(c => c.id == testCollect.testcollect.op3).Select(c => c.eText).FirstOrDefault(),
                 Question = testCollect.testcollect.question,
                 Op1ImagePath = db.Collections.Where(c => c.id == testCollect.testcollect.op1).Select(c => c.picPath).FirstOrDefault(),
                 Op2ImagePath = db.Collections.Where(c => c.id == testCollect.testcollect.op2).Select(c => c.picPath).FirstOrDefault(),
                 Op3ImagePath = db.Collections.Where(c => c.id == testCollect.testcollect.op3).Select(c => c.picPath).FirstOrDefault(),
                 Op1Audio = db.Collections.Where(c => c.id == testCollect.testcollect.op1).Select(c => c.audioPath).FirstOrDefault(),
                 Op2Audio = db.Collections.Where(c => c.id == testCollect.testcollect.op2).Select(c => c.audioPath).FirstOrDefault(),
                 Op3Audio = db.Collections.Where(c => c.id == testCollect.testcollect.op3).Select(c => c.audioPath).FirstOrDefault(),
                 AssigningUserId = testCollect.app.appointment.appoint.userId
             })
              .Join(db.Users, pc => pc.AssigningUserId, u => u.uid, (TestCollect, user) => new {
                  TestCollect.AppointmentDate,
                  TestCollect.AppointmentId,
                  TestCollect.testCollectionID,
                  TestCollect.TestId,
                  TestCollect.CollectId,
                  TestCollect.Path,
                  TestCollect.Etext,
                  TestCollect.Utext,
                  TestCollect.Group,
                  TestCollect.Type,
                  TestCollect.collectAudio,
                  TestCollect.Opt1,
                  TestCollect.Opt2,
                  TestCollect.Opt3,
                  TestCollect.Opt1eText,
                  TestCollect.Opt2eText,
                  TestCollect.Opt3eText,
                  TestCollect.Question,
                  TestCollect.Op1ImagePath,
                  TestCollect.Op2ImagePath,
                  TestCollect.Op3ImagePath,
                  TestCollect.Op1Audio,
                  TestCollect.Op2Audio,
                  TestCollect.Op3Audio,
                  UserType = user.type
              })
             .GroupBy(e => new { e.AppointmentDate, e.UserType, e.TestId,e.AppointmentId })

                .Select(group => new
                {
                    Appointment = group.Key.AppointmentDate,
                    group.Key.UserType,
                    group.Key.AppointmentId,
                    group.Key.TestId,
                    Collections = group.Select(e => new
                    {
                        e.UserType,
                        e.AppointmentDate,
                        e.AppointmentId,
                        e.testCollectionID,
                        e.CollectId,
                        e.Path,
                        e.Etext,
                        e.Utext,
                        e.Group,
                        e.Type,
                        e.Opt1,
                        e.Opt2,
                        e.Opt3,
                        e.Opt1eText,
                        e.Opt2eText,
                        e.Opt3eText,
                        e.Op1ImagePath,
                        e.Op2ImagePath,
                        e.Op3ImagePath,
                        e.Question,
                        e.collectAudio,
                        e.Op1Audio,
                        e.Op2Audio,
                        e.Op3Audio,
                    }).OrderByDescending(c => c.AppointmentDate).ToList()
                }).OrderByDescending(g => g.Appointment) // Order appointments by most recent first
            .ToList(); // Ensure the query executes and results are fetched


            //var singleTest=data.Where(t=>t.testId)
            if (filter == "all")
            {
                List<PatientPerformTestModel> pptmlist = new List<PatientPerformTestModel>();
                
                foreach(var d in data) 
                {
                    List<PatientPerformTest> pptlist = new List<PatientPerformTest>();
                    PatientPerformTestModel pptm = new PatientPerformTestModel();
                    pptm.TestId = d.TestId??-1;
                    pptm.aptId = d.AppointmentId;
                    foreach(var c in d.Collections) 
                    {
                        PatientPerformTest ppt = new PatientPerformTest();
                        byte[] imageBytes = new byte[] { };
                        ppt.Opt1 = c.Opt1??-1;
                        ppt.Opt2 = c.Opt2??-1;
                        ppt.Type = c.Type;
                        ppt.Group = c.Group;
                        ppt.Opt1eText = c.Opt1eText;
                        ppt.Opt2eText = c.Opt2eText;
                        ppt.Opt3eText = c.Opt3eText;
                        imageBytes = File.ReadAllBytes(c.Op3Audio);
                        ppt.Op3Audio = Convert.ToBase64String(imageBytes);
                        imageBytes = File.ReadAllBytes(c.Op2Audio);
                        ppt.Op2Audio = Convert.ToBase64String(imageBytes);
                        imageBytes = File.ReadAllBytes(c.Op1Audio);
                        ppt.Op1Audio = Convert.ToBase64String(imageBytes);
                        ppt.Utext = c.Utext;
                        ppt.Etext = c.Etext;
                        imageBytes = File.ReadAllBytes(c.collectAudio);
                        ppt.collectAudio = Convert.ToBase64String(imageBytes);
                        ppt.Question = c.Question;
                        imageBytes = File.ReadAllBytes(c.Op3ImagePath);
                        ppt.Op3ImagePath = Convert.ToBase64String(imageBytes);
                        imageBytes = File.ReadAllBytes(c.Op2ImagePath);
                        ppt.Op2ImagePath = Convert.ToBase64String(imageBytes);
                        imageBytes = File.ReadAllBytes(c.Op1ImagePath);
                        ppt.Op1ImagePath = Convert.ToBase64String(imageBytes);
                        ppt.UserType = c.UserType;
                        ppt.AppointmentDate = c.AppointmentDate;
                        ppt.AppointmentId = c.AppointmentId;
                        ppt.testCollectionID = c.testCollectionID;
                        ppt.CollectId = c.CollectId;
                        ppt.Opt3 = c.Opt3??-1;
                        imageBytes = File.ReadAllBytes(c.Path);
                        ppt.Path = Convert.ToBase64String(imageBytes);
                        pptlist.Add(ppt);
                    }
                    pptm.Collections=pptlist;
                    pptmlist.Add(pptm);
                }
                return Request.CreateResponse(HttpStatusCode.OK, pptmlist);
            }
            else
            {
                var filteredData = data
                    .GroupBy(d => d.UserType)
                    .Select(group => group.FirstOrDefault())
                    .ToList();

                return Request.CreateResponse(HttpStatusCode.OK, filteredData);
            }

        }
        [HttpGet]
        public HttpResponseMessage SignInPatient(string username, string password)
        {
            try
            {
                var data = db.Users.Where(e => e.username == username && e.password == password).Select(user => new { user.uid, user.type, user.profPicPath, user.name, user.username, user.password }).FirstOrDefault();
                if (data == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NonAuthoritativeInformation, "invalid Username Or Password");
                }
                var data1 = db.UserPatients.Where(c => c.userId == data.uid).FirstOrDefault();
                if (data1 == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "Patient does not exist against user");
                }
                var patient = db.Patients.FirstOrDefault(p => p.pid == data1.patientId);
                Patient u = new Models.Patient();
                u.pid = patient.pid;
                u.name = patient.name;
                u.age = patient.age;
                u.stage = patient.stage;
                u.userName = patient.userName;
                u.password = patient.password;
                u.gender = patient.gender;
                u.firstTime = patient.firstTime;
                u.profPicPath = patient.profPicPath;
                byte[] imageBytes = File.ReadAllBytes(u.profPicPath);
                u.profPicPath = Convert.ToBase64String(imageBytes);
                return Request.CreateResponse(HttpStatusCode.OK, u);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "Whoops" + ex.Message + ex.InnerException);
            }

        }
        [HttpGet]
        public HttpResponseMessage updateAppointmentFeedback(int appointid, string feedback)
        {
            var data = db.Appointments.Where(e => e.id == appointid).FirstOrDefault();
            data.feedback = feedback;
            db.SaveChanges();
            var newData = new { data.id, data.patientId, data.feedback };
            return Request.CreateResponse(HttpStatusCode.OK, newData);
        }
        [HttpGet]
        public HttpResponseMessage GetAppointments(int Did, DateTime date)
        {
            try
            {
                db.Configuration.ProxyCreationEnabled = false;
                db.Configuration.LazyLoadingEnabled = false;

                // Truncate time part from the date parameter
                DateTime startDate = date.Date;
                DateTime endDate = startDate.AddDays(1); // Assuming you want appointments for the entire day

                var data = db.Appointments
                .Where(e => e.userId == Did && e.nextAppointDate >= startDate && e.nextAppointDate < endDate).
                Join(db.Patients, app => app.patientId, pat => pat.pid, (app, pat) => new
                {
                    app.id,
                    app.patientId,
                    app.feedback,
                    app.nextAppointDate,
                    pat.profPicPath,
                    pat.stage,
                    pat.name,
                    pat.gender,
                    pat.password,
                    pat.age,
                    pat.userName,
                    pat.firstTime,
                    pat.pid
                }).ToList();
                Patient patients = new Patient();
                Appointment appointments = new Appointment();
                List<DocPatientApt> dpalist =new List<DocPatientApt>();
                foreach (var d in data)
                {
                    Patient ap = new Patient();
                    ap.pid = d.pid;
                    ap.name = d.name;
                    ap.stage = d.stage;
                    ap.gender = d.gender;
                    ap.userName = d.userName;
                    ap.firstTime = d.firstTime;
                    ap.password = d.password;
                    ap.age = d.age;
                    byte[] imageBytes = File.ReadAllBytes(d.profPicPath);
                    ap.profPicPath = Convert.ToBase64String(imageBytes);
                    patients=ap;
                    Appointment a = new Appointment();
                    a.id = d.id;
                    a.feedback = d.feedback;
                    a.nextAppointDate = d.nextAppointDate;
                    a.patientId = d.patientId;
                    a.userId = Did;
                    appointments = a;
                    DocPatientApt dpa = new DocPatientApt();
                    dpa.appointment = a;
                    dpa.patients = ap;
                    dpalist.Add(dpa);
                }
                return Request.CreateResponse(HttpStatusCode.OK, dpalist);
            }catch(Exception ex) 
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message+ex.InnerException);
            }
            
        }

        
        [HttpGet]
        public HttpResponseMessage showSpacificAppointmentData(int did, int pid)
        {
            try
            {
                var prevDate = db.Appointments.Where(e => e.patientId == pid && e.userId == did).OrderByDescending(e => e.appointmentDate).FirstOrDefault();
                if (prevDate == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "No previous appointment found.");
                }
                var testData = db.Appointments
                 .Where(e => e.patientId == pid && e.appointmentDate >= prevDate.appointmentDate)
                 .Join(db.AppointmentTests, appoint => appoint.id, testapt => testapt.appointmentId, (appoint, testapt) => new { appoint, testapt })
                 .Join(db.Tests, testapt => testapt.testapt.testId, test => test.id, (testapt, test) => new
                 {
                     test.title
                 }).ToList();
                var practiceData = db.Appointments
                 .Where(e => e.patientId == pid && e.appointmentDate >= prevDate.appointmentDate)
                 .Join(db.AppointmentPractices, appoint => appoint.id, testapt => testapt.appointmentId, (appoint, testapt) => new { appoint, testapt })
                 .Join(db.Practices, testapt => testapt.testapt.practiceId, test => test.id, (testapt, test) => new
                 {
                     test.title
                 }).ToList();
                var data = new
                {
                    tests = testData,
                    practices = practiceData
                };
                return Request.CreateResponse(HttpStatusCode.OK, data);
                /*var TestData = db.PatientTestCollectionFeedbacks.Where(e => e.AppointmentId == AppointmentId && e.patientId == pid)
                *//*.Join(db.AppointmentTest, appoint => appoint.id, AppointmentTest => AppointmentTest.appointmentId, (appoint, appointmentTest) => new { appoint, appointmentTest })
                .Join(db.TestCollection, appointtest => appointtest.appointmentTest.testId, testcollection => testcollection.testId, (appoint, testcollection) => new { appoint, testcollection }).
                Join(db.PatientTestCollectionFeedback, ttc => ttc.testcollection.id, ptcf => ptcf.id, (appointTestCollection, pTestColletFedback) => new { appointTestCollection, pTestColletFedback })*//*
                .Join(db.Collections, ptcf => ptcf.collectionId, collect => collect.id, (Ptch, collect) => new
                {
                    collect.eText,
                    collect.uText,
                    collect.type,
                    Ptch.feedback,


                });
                var PracticeData = db.Appointments.Where(e => e.id == AppointmentId && e.patientId == pid)
                    .Join(db.PracticeCollections, appoint => appoint.pracId, practicecollection => practicecollection.pracId, (appoint, pracCollection) => new { appoint, pracCollection })


                    .Join(db.Collections, ptcf => ptcf.pracCollection.collectId, collect => collect.id, (all, collect) => new
                    {
                        collect.eText,
                        collect.uText,
                        all.appoint.userId
                    }).ToList();
                var uid = PracticeData[0].userId;
                var result = new { uid, PracticeData, TestData };

                return Request.CreateResponse(HttpStatusCode.OK, TestData);*/
            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, ex.Message+ex.InnerException);
            }
        }
        [HttpGet]
        public HttpResponseMessage GetAllpatiets(int Did)
        {
            try
            {
                var data = db.Users.Where(e => e.uid == Did)
                    .Join(db.UserPatients, user => user.uid, userpatient => userpatient.userId, (user, userpatient) => new { user, userpatient })
                    .Join(db.Patients, UserPatient => UserPatient.userpatient.patientId, patient => patient.pid, (userPatient, patient) => new {
                        patient.pid,
                        patient.name,
                        patient.age,
                        patient.profPicPath

                    }).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, data);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.OK, ex.Message);
            }

        }
        [HttpGet]
        public HttpResponseMessage allDoctors()
        {
            try 
            {
                var docsList = db.Users.Where(d => d.type == "doctor").Select(d => new
                {
                    d.uid,
                    d.name,
                    d.profPicPath
                }).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, docsList);
            }
            catch(Exception e) {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "An error has occoured.");
            }
        }
        [HttpGet]
        public HttpResponseMessage previousDoctorAppointment(int did, int pid)
        {
            try
            {
                var prevDate = db.Appointments.Where(e => e.patientId == pid && e.userId == did).OrderByDescending(e => e.appointmentDate).FirstOrDefault();
                if (prevDate == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "No previous appointment found.");
                }
                var testData = db.Appointments
                 .Where(e => e.id==prevDate.id)
                 .Join(db.AppointmentTests, appoint => appoint.id, testapt => testapt.appointmentId, (appoint, testapt) => new { appoint, testapt })
                 .Join(db.Tests, testapt => testapt.testapt.testId, test => test.id, (testapt, test) => new
                 {
                     test.id
                 }).ToList();
                var practiceData = db.Appointments
                 .Where(e => e.id==prevDate.id)
                 .Join(db.AppointmentPractices, appoint => appoint.id, testapt => testapt.appointmentId, (appoint, testapt) => new { appoint, testapt })
                 .Join(db.Practices, testapt => testapt.testapt.practiceId, test => test.id, (testapt, test) => new
                 {
                     test.id
                 }).ToList();
                var data = new
                {
                    tests = testData,
                    practices = practiceData
                };
                return Request.CreateResponse(HttpStatusCode.OK, data);
            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, ex.Message + ex.InnerException);
            }
        }
        [HttpGet]
        public HttpResponseMessage NextVisit(int pid)
        {
            try
            {
                var data = db.Patients.Where(e => e.pid == pid)
                    .Join(db.Appointments, patient => patient.pid, appoint => appoint.patientId, (Patient, appoint) => new { Patient, appoint })
                    .Join(db.Users, User => User.appoint.userId, user => user.uid, (patAppoint, user) => new {
                        patAppoint.appoint.nextAppointDate,
                        user.name,user.username

                    }).OrderByDescending(patAppoint => patAppoint.nextAppointDate) // Order by appointment date descending
                        .Select(result => new {
                            result.nextAppointDate,
                            result.name,
                            result.username
                        })
                        .FirstOrDefault();
                
                return Request.CreateResponse(HttpStatusCode.OK, data);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.OK, ex.Message);
            }

        }
        [HttpGet]
        public HttpResponseMessage AcceptPatientRequest(int pid, int uid)
        {
            try
            {
                var data = db.CaregiverPurposals.Where(e => e.PatientId == pid).FirstOrDefault();
                data.Status = "Accepted";
                db.SaveChanges();
                UserPatient up = new UserPatient();
                up.patientId = pid;
                up.userId = uid;
                db.UserPatients.Add(up);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Accepted");
            }
            catch (Exception ex) { return Request.CreateResponse(HttpStatusCode.NotFound, ex.Message); }
        }
        [HttpPost]
        public HttpResponseMessage CaregiverRegisterPatient()
        {

            var request = HttpContext.Current.Request;
            var username = request["username"];
            var validation = db.Patients.Where(e => e.userName == username);

            if (validation == null)
            {
                return Request.CreateResponse(HttpStatusCode.OK, "Username Already exist");
            }

            var name = request["name"];
            var age = int.Parse(request["age"]);
            var gender = request["gender"];
            //var stage = int.Parse(request["stage"]);

            var password = request["password"];
            var profpic = request.Files["profpic"];
            var caregiverid = int.Parse(request["caregiverid"]);
            var DoctorId = int.Parse(request["DoctorId"]);
            Patient patient = new Patient();

            patient.age = age;
            patient.gender = gender;
            patient.name = name;
            patient.userName = username;
            patient.stage = 1;
            patient.firstTime = true;
            patient.password = password;



            string fileName = patient.userName.Split('.')[0] + "." + profpic.FileName.Split('.')[1];
            profpic.SaveAs(HttpContext.Current.Server.MapPath("~/Media/PatientsImages/" + fileName));
            patient.profPicPath = "C:\\Users\\us\\source\\LearnSpaceApi\\LearnSpaceApi\\Media\\PatientsImages\\" + fileName;
            db.Patients.Add(patient);
            db.SaveChanges();
            UserPatient CaregivePatient = new UserPatient();
            CaregivePatient.userId = caregiverid;
            CaregivePatient.patientId = patient.pid;
            db.UserPatients.Add(CaregivePatient);
            db.SaveChanges();
            CaregiverPurposal CP = new CaregiverPurposal();
            CP.PatientId = patient.pid;
            CP.UserId = DoctorId;
            CP.Status = "sent";
            db.CaregiverPurposals.Add(CP);
            db.SaveChanges();
            return Request.CreateResponse(HttpStatusCode.OK, "registerd");



            /* var request = HttpContext.Current.Request;
             var username = request["username"];
             var validation = db.Patients.Where(e => e.userName == username);

             if (validation == null)
             {
                 return Request.CreateResponse(HttpStatusCode.OK, "Username Already exist");
             }

             var name = request["name"];
             var age = int.Parse(request["age"]);
             var gender = request["gender"];
             var stage = int.Parse(request["stage"]);

             var password = request["password"];
             var profpic = request.Files["profpic"];
             var caregiverid = int.Parse(request["caregiverid"]);
             Patient patient = new Patient();

             patient.age = age;
             patient.gender = gender;
             patient.name = name;
             patient.userName = username;
             patient.stage = stage;
             patient.firstTime = true;
             patient.password = password;



             string fileName = patient.userName.Split('.')[0] + "." + profpic.FileName.Split('.')[1];
             profpic.SaveAs(HttpContext.Current.Server.MapPath("~/Media/PatientsImages/" + fileName));
             patient.profPicPath = "/Media/PatientsImages/" + fileName;
             db.Patients.Add(patient);
             db.SaveChanges();
             UserPatient CaregivePatient = new UserPatient();
             CaregivePatient.userId = caregiverid;
             CaregivePatient.patientId = patient.pid;
             db.UserPatients.Add(CaregivePatient);
             db.SaveChanges();
             return Request.CreateResponse(HttpStatusCode.OK, "registerd");*/
        }

        [HttpPost]
        public HttpResponseMessage TestComputation([FromBody] List<TestResultComputation> AssignTestData)
        {

            try
            {
                string responce = "";
                if (AssignTestData.Count == 1)
                {
                    responce = computeTestResult(AssignTestData[0]);
                }
                else
                {
                    responce = computeTestResult(AssignTestData[0]);
                    responce += computeTestResult(AssignTestData[1]);
                }

                return Request.CreateResponse(HttpStatusCode.OK, responce);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        private string computeTestResult(TestResultComputation AssignTestData)
        {
            var check = db.PatientTestCollectionFeedbacks.Where(e => e.AppointmentId == AssignTestData.AppointmentId).ToList();
            if (check.Any())
            {
                return "Already Submited ";
            }
            int appointId = AssignTestData.AppointmentId;
            var data = db.AppointmentTests.Where(e => e.appointmentId == appointId)
                .Join(db.Tests, apptest => apptest.testId, test => test.id, (apptest, test) => new { apptest, test })
                .Join(db.TestCollections, test => test.test.id, testcolect => testcolect.testId, (apptestTest, testCollect) => new { apptestTest, testCollect })
                .Join(db.Collections, testCollect => testCollect.testCollect.collectId, collect => collect.id, (testColl, coll) => new
                {
                    testColl.testCollect.id,
                    collectId = coll.id
                }).ToList();
            bool[] result = new bool[AssignTestData.SelectedOptions.Count];
            int count = 0;
            foreach (var item in data)
            {
                if (item.collectId == AssignTestData.SelectedOptions[count])
                {
                    result[count] = true;
                }
                count++;
            }
            List<PatientTestCollectionFeedback> patientTestCollectionFeedback = new List<PatientTestCollectionFeedback>();

            count = 0;
            foreach (var item in data)
            {
                PatientTestCollectionFeedback p = new PatientTestCollectionFeedback();
                p.patientId = AssignTestData.Pid;
                p.testCollectionId = item.id;
                p.collectionId = item.collectId;
                p.feedback = result[count];
                p.AppointmentId = AssignTestData.AppointmentId;
                patientTestCollectionFeedback.Add(p);

                count++;
            }
            db.PatientTestCollectionFeedbacks.AddRange(patientTestCollectionFeedback);
            db.SaveChanges();
            return "Submit Successfullt";
        }
    }

}