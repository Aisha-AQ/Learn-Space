using LearnSpaceApi.Models;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.ModelBinding;

namespace LearnSpaceApi.Controllers
{
    public class PatientsController : ApiController
    {

        slowlearnerDataBaseEntities db = new slowlearnerDataBaseEntities();
        [HttpPost]
        public HttpResponseMessage registerPatient()
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
            Patient patient = new Patient();

            patient.age = age;
            patient.gender = gender;
            patient.name = name;
            patient.userName = username;
            //patient.stage = stage;
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
            return Request.CreateResponse(HttpStatusCode.OK, "registerd");
        }
        [HttpGet]
        public HttpResponseMessage AssignedPractic(int Pid, string filter)
        {
            var data = db.Patients
             .Where(e => e.pid == Pid)
             .Join(db.Appointments, p => p.pid, ap => ap.patientId, (patien, appoint) => new { patien, appoint })
             .Join(db.PracticeCollections, ap => ap.appoint.pracId, pc => pc.pracId, (appoint, pracCollect) => new { appoint, pracCollect })
             .Join(db.Collections, prac => prac.pracCollect.collectId, c => c.id, (pracCollect, collect) => new
             {
                 AppointmentDate = pracCollect.appoint.appoint.id,
                 PracticeCollectionssId = pracCollect.pracCollect.id,
                 CollectId = collect.id,
                 Path = collect.picPath,
                 Etext = collect.eText,
                 Utext = collect.uText,
                 Group = collect.C_group,
                 Type = collect.type,
             })
             .OrderByDescending(e => e.AppointmentDate)
             .GroupBy(e => e.AppointmentDate)
             .Select(group => new
             {
                 AppointmentsDate = group.Key,
                 Collectionss = group.Select(e => new
                 {
                     e.PracticeCollectionssId,
                     e.CollectId,
                     e.Path,
                     e.Etext,
                     e.Utext,
                     e.Group,
                     e.Type,
                 }).ToList()
             });
            // .FirstOrDefault();
            if (filter == "all")
            {
                return Request.CreateResponse(HttpStatusCode.OK, data);
            }


            return Request.CreateResponse(HttpStatusCode.OK, data.FirstOrDefault());
        }
        [HttpGet]
        public HttpResponseMessage AssignedPractice(int Pid, DateTime date)
        {
            try 
            {
                DateTime startDate = date.Date;
                DateTime endDate = startDate.AddDays(1);
                //var data = db.Appointments.Where(e => e.patientId == Pid && e.nextAppointDate >= startDate && e.nextAppointDate < endDate).ToList();
                var PracticeData = db.Appointments.Where(e => e.nextAppointDate >= startDate && e.nextAppointDate < endDate && e.patientId == Pid)
                    .Join(db.AppointmentPractices, appoint => appoint.id, appoimtPrac => appoimtPrac.appointmentId, (appoint, appointmentPractic) => new { appoint, appointmentPractic })
                    .Join(db.PracticeCollections, AppointmentPractic => AppointmentPractic.appointmentPractic.practiceId, practicecollection => practicecollection.pracId, (appoint, pracCollection) => new { appoint, pracCollection })
                    .Join(db.Collections, ptcf => ptcf.pracCollection.collectId, collect => collect.id, (all, collect) => new
                    {
                        collect.eText,
                        collect.uText,
                        collect.type,
                        all.appoint.appoint.userId,
                    }).ToList();
                var uid = PracticeData[0].userId;
                var result = new { uid, PracticeData };
                return Request.CreateResponse(HttpStatusCode.OK, result);
            }catch(Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message+ex.InnerException);
            }
            
        }

        [HttpGet]
        public HttpResponseMessage AssignedTest(int Pid, string filter)
        {
            var data = db.Patients
             .Where(e => e.pid == Pid)
             .Join(db.Appointments, p => p.pid, ap => ap.patientId, (patien, appoint) => new { patien, appoint })
             .Join(db.TestCollections, ap => ap.appoint.testId, tc => tc.testId, (appoint, testcollect) => new { appoint, testcollect })
             .Join(db.Collections, test => test.testcollect.collectId, c => c.id, (testCollect, collect) => new
             {
                 AppointmentsDate = testCollect.appoint.appoint.id,
                 testCollectionsID = testCollect.testcollect.id,
                 CollectId = collect.id,
                 Path = collect.picPath,
                 Etext = collect.eText,
                 Utext = collect.uText,
                 Group = collect.C_group,
                 Type = collect.type,
                 Opt1 = testCollect.testcollect.op1,
                 Opt2 = testCollect.testcollect.op2,
                 Opt3 = testCollect.testcollect.op3
             })
             .OrderByDescending(e => e.AppointmentsDate)
             .GroupBy(e => e.AppointmentsDate)
             .Select(group => new
             {
                 AppointmentsDate = group.Key,
                 Collectionss = group.Select(e => new
                 {
                     e.testCollectionsID,
                     e.CollectId,
                     e.Path,
                     e.Etext,
                     e.Utext,
                     e.Group,
                     e.Type,
                     e.Opt1,
                     e.Opt2,
                     e.Opt3,


                 }).ToList()
             });


            if (filter == "all")
            {
                return Request.CreateResponse(HttpStatusCode.OK, data);
            }


            return Request.CreateResponse(HttpStatusCode.OK, data.FirstOrDefault());


        }
        [HttpGet]
        public HttpResponseMessage computeTestResult([FromBody] int[] SelectedAns, int testId, int pid)
        {


            var data = db.TestCollections.Where(e => e.testId == testId)
                .Join(db.Collections, tc => tc.collectId, coll => coll.id, (testColl, coll) => new
                {
                    testColl.id,
                    collectId = coll.id
                }).ToList();
            bool[] result = new bool[SelectedAns.Length];
            int count = 0;
            foreach (var item in data)
            {
                if (item.collectId == SelectedAns[count])
                {
                    result[count] = true;
                }
                count++;
            }
            List<PatientTestCollectionFeedback> PatientsTestCollectionsFeedback = new List<PatientTestCollectionFeedback>();

            count = 0;
            foreach (var item in data)
            {
                PatientTestCollectionFeedback p = new PatientTestCollectionFeedback();
                p.patientId = pid;
                p.testCollectionId = item.id;
                p.collectionId = item.collectId;
                p.feedback = result[count];
                PatientsTestCollectionsFeedback.Add(p);
                count++;
            }
            db.PatientTestCollectionFeedbacks.AddRange(PatientsTestCollectionsFeedback);
            db.SaveChanges();
            return Request.CreateResponse(HttpStatusCode.OK, PatientsTestCollectionsFeedback);

        }
    }

}