using LearnSpaceApi.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Runtime.Remoting.Messaging;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace LearnSpaceApi.Controllers
{
    public class PersonController : ApiController
    {
        slowlearnerDataBaseEntities db = new slowlearnerDataBaseEntities();
        private static readonly HttpClient client = new HttpClient
        {
            BaseAddress = new Uri("http://127.0.0.1:5000")
        };
        [HttpPost]
        public async Task<HttpResponseMessage> UploadPersonData(int forceAdd)
        {
            try
            {
                var request = HttpContext.Current.Request;
                var name = request["name"];
                var gender = request["gender"];
                var age = int.Parse(request["age"]);
                var relation = request["relation"];
                var nameAudio = request.Files["audio"];
                var namePic = request.Files["picture"];
                var caregiverId = int.Parse(request["addBy"]);

                Person p = new Person();
                p.name = name;
                p.age = age;
                p.gender = gender;
                p.relation = relation;
                p.addBy = caregiverId;

                if (forceAdd == 0)
                {
                    var exists = db.People.Where(x => x.name == p.name && x.relation == p.relation).FirstOrDefault();
                    if (exists != null)
                    {
                        return Request.CreateResponse(HttpStatusCode.Conflict, "Person data already exists against " + p.name + " with the relation " + p.relation + "\nDo you want to continue?");
                    }
                    var existsname = db.People.Where(x => x.name == p.name).FirstOrDefault();
                    if (existsname != null)
                    {
                        return Request.CreateResponse(HttpStatusCode.Ambiguous, "Person data already exists against " + p.name);
                    }

                }

                var id = db.People.OrderByDescending(x => x.id).Select(x => x.id).FirstOrDefault();


                if (nameAudio != null && nameAudio.ContentLength > 0)
                {
                    string audioFileName = $"{id + 1}.{nameAudio.FileName.Split('.')[1]}";
                    nameAudio.SaveAs(HttpContext.Current.Server.MapPath("~/Media/Person/audio/" + audioFileName));
                    p.audioPath = "C:\\Users\\us\\source\\LearnSpaceApi\\LearnSpaceApi\\Media\\Person\\audio\\" + audioFileName;
                }
                if (namePic != null && namePic.ContentLength > 0)
                {
                    string picfileName = $"{id + 1}.{namePic.FileName.Split('.')[1]}";
                    namePic.SaveAs(HttpContext.Current.Server.MapPath("~/Media/Person/Images/" + picfileName));
                    p.picPath = "C:\\Users\\us\\source\\LearnSpaceApi\\LearnSpaceApi\\Media\\Person\\Images\\" + picfileName;
                }
                db.People.Add(p);
                var apiResponse = new FlaskAPiResponce();
                if (namePic != null && namePic.ContentLength > 0)
                {
                    db.SaveChanges();
                    // Handle single file upload
                    string basePath = @"C:\Users\us\PycharmProjects\FaceDetection\venv\training-data";

                    // Create the full path to the new folder
                    string folderPath = Path.Combine(basePath, p.id.ToString());

                    // Create a folder named after the ID
                    Directory.CreateDirectory(folderPath);

                    // Check if the imageFile is not null and has content

                    string fileName = Path.GetFileName(namePic.FileName);
                    string destPath = Path.Combine(folderPath, fileName);

                    // Save the file to the specified path
                    namePic.SaveAs(destPath);



                    HttpResponseMessage response = await client.GetAsync("/prepare-training-data");
                    response.EnsureSuccessStatusCode();
                    string responseBody = await response.Content.ReadAsStringAsync();
                    apiResponse = JsonConvert.DeserializeObject<FlaskAPiResponce>(responseBody);


                }

                return Request.CreateResponse(HttpStatusCode.OK, "inserted");
            }
            catch (Exception e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Message+e.InnerException);
            }
        }
        [HttpPost]

        public async Task<HttpResponseMessage> Upload()
        {
            var httpRequest = HttpContext.Current.Request;
            var file = httpRequest.Files["personPic"];

            if (file == null || file.ContentLength == 0)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, "No file uploaded");
            }

            using (var memoryStream = new MemoryStream())
            {
                file.InputStream.CopyTo(memoryStream);
                var byteArrayContent = new ByteArrayContent(memoryStream.ToArray());
                byteArrayContent.Headers.ContentType = new MediaTypeHeaderValue(file.ContentType);

                using (var multipartContent = new MultipartFormDataContent())
                {
                    multipartContent.Add(byteArrayContent, "file", file.FileName);
                    var response = await client.PostAsync("/PersonImage", multipartContent);

                    if (response.IsSuccessStatusCode)
                    {
                        var apiResponse = new FlaskAPiResponce();
                        var responseContent = await response.Content.ReadAsStringAsync();
                        apiResponse = JsonConvert.DeserializeObject<FlaskAPiResponce>(responseContent);
                        int personId = int.Parse(apiResponse.Message);
                        var person = db.People.Where(e => e.id == personId).Select(e => new
                        {
                            e.name,
                            e.gender,
                            e.age,
                            e.picPath,
                            e.audioPath
                        }).FirstOrDefault();
                        var data = db.Sentences.Select(e => new { e.sentence1 }).ToList();
                        string[] Sentence = new string[data.Count];
                        for (int i = 0; i < data.Count; i++)
                        {
                            Sentence[i] = data[i].sentence1.Replace("[Name]", person.name);
                        }
                        var SendData = new { person, Sentence };
                        return Request.CreateResponse(HttpStatusCode.OK, SendData);
                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, response.ReasonPhrase);
                    }
                }
            }
            /*var httpRequest = HttpContext.Current.Request;
            var file = httpRequest.Files["personPic"];

            if (file == null || file.ContentLength == 0)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, "No file uploaded");
            }

            using (var memoryStream = new MemoryStream())
            {
                file.InputStream.CopyTo(memoryStream);
                var byteArrayContent = new ByteArrayContent(memoryStream.ToArray());
                byteArrayContent.Headers.ContentType = new MediaTypeHeaderValue(file.ContentType);

                using (var multipartContent = new MultipartFormDataContent())
                {
                    multipartContent.Add(byteArrayContent, "file", file.FileName);
                    var response = await client.PostAsync("/PersonImage", multipartContent);

                    if (response.IsSuccessStatusCode)
                    {
                        var apiResponse = new FlaskAPiResponce();
                        var responseContent = await response.Content.ReadAsStringAsync();
                        apiResponse = JsonConvert.DeserializeObject<FlaskAPiResponce>(responseContent);
                        int personId = int.Parse(apiResponse.Message);
                        var person = db.People.Where(e => e.id == personId).Select(e => new
                        {
                            e.name,
                            e.picPath,
                            e.age,
                            e.gender,
                            e.audioPath
                        }).FirstOrDefault();
                        return Request.CreateResponse(HttpStatusCode.OK, person);

                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, response.ReasonPhrase);
                    }
                }
            }*/
        }
        [HttpGet]
        public HttpResponseMessage Getpersons(int CaregiverId)
        {
            try
            {
                List<Person> plist = new List<Person>();
                foreach (Person p in db.People)
                {
                    if (p.picPath != null&&p.addBy==CaregiverId)
                    {
                        Person po = new Person();
                        byte[] imageBytes = File.ReadAllBytes(p.picPath);
                        po.picPath = Convert.ToBase64String(imageBytes);
                        po.id = p.id;
                        po.name = p.name;
                        po.gender = p.gender;
                        po.age = p.age;
                        po.relation = p.relation;
                        plist.Add(po);
                    }


                }

                var data = db.People.Where(e => e.addBy == CaregiverId).Select(person => new
                {

                    person.id,
                    person.picPath,
                    person.name,
                    person.gender,
                    person.age,
                    person.relation
                }).ToList();

                return Request.CreateResponse(HttpStatusCode.OK, plist);
            }catch(Exception w) 
            {
                return Request.CreateResponse(HttpStatusCode.OK, w.Message+w.InnerException);
            }
        }
        
        [HttpPost]

        public HttpResponseMessage Addpractice(PersonPracticeInfo info)
        {
            db.PersonPractices.Add(info.PersonPractice);
            db.SaveChanges();

            foreach (var item in info.Persons)
            {
                item.personPractice = info.PersonPractice.id;


            }
            db.PersonPracticCollections.AddRange(info.Persons);
            db.SaveChanges();
            return Request.CreateErrorResponse(HttpStatusCode.OK, "data save");
        }

        [HttpGet]
        public HttpResponseMessage GetPersonpracticesWithDetail(int uid)
        {
            var data = db.PersonPractices.Where(e => e.createdBy == uid)
                .Join(db.PersonPracticCollections, personprac => personprac.id, personPracColl => personPracColl.personPractice, (personPrac, personPracColl) => new { personPrac, personPracColl })
                .Join(db.People, personpraccoll => personpraccoll.personPracColl.personId, person => person.id, (PersonPracColl, person) => new { PersonPracColl, person })
                .Join(db.PersonPictures, person => person.person.id, personpics => personpics.personid, (PersonPracColl, personpics) => new
                {
                    PInfo = PersonPracColl.PersonPracColl.personPrac,
                    personpics,
                    PersonDetail = PersonPracColl.person,

                }).GroupBy(e => e.PInfo.title)
                    .Select(group => new
                    {
                        Id = group.Key,
                        PersonDetails = group.Select(item => new
                        {
                            item.PersonDetail,
                            item.personpics
                        }),

                    });
            return Request.CreateResponse(HttpStatusCode.OK, data);





        }

        [HttpGet]
        public HttpResponseMessage GetPersonpractice(int uid)
        {
            var data = db.PersonPractices.Where(e => e.createdBy == uid).Select(w => new {w.id,w.title,w.patientId,w.createdBy}).ToList();
            return Request.CreateResponse(HttpStatusCode.OK, data);






        }
        [HttpGet]
        public HttpResponseMessage GetAssignPersonTest(int Pid)
        {
            var data = db.Patients
             .Where(e => e.pid == Pid)
             .Join(db.Appointments, p => p.pid, ap => ap.patientId, (patien, appoint) => new { patien, appoint })
             .Join(db.AppointmentPersonTests, p => p.appoint.id, c => c.appointmentId, (appointment, appointTest) => new { appointment, appointTest })
             .Join(db.PersonTestCollections, ap => ap.appointTest.personTestId, tc => tc.personTestId, (app, testcollect) => new { app, testcollect })
             .Join(db.People, test => test.testcollect.personId, c => c.id, (testCollect, collect) => new
             {
                 AppointmentDate = testCollect.app.appointment.appoint.appointmentDate,
                 AppointmentId = testCollect.app.appointment.appoint.id,
                 testCollectionID = testCollect.testcollect.id,
                 CollectId = collect.id,
                 Path = collect.picPath,
                 Name = collect.name,
                 
                 
                
                 collectAudio = collect.audioPath,
                 Opt1 = testCollect.testcollect.op1,
                 Opt2 = testCollect.testcollect.op2,
                 Opt3 = testCollect.testcollect.op3,
                 Question = testCollect.testcollect.questionTitle,
                 Op1ImagePath = db.People.Where(c => c.id == testCollect.testcollect.op1).Select(c => c.picPath).FirstOrDefault(),
                 Op2ImagePath = db.People.Where(c => c.id == testCollect.testcollect.op2).Select(c => c.picPath).FirstOrDefault(),
                 Op3ImagePath = db.People.Where(c => c.id == testCollect.testcollect.op3).Select(c => c.picPath).FirstOrDefault(),
                 Op1Audio = db.People.Where(c => c.id == testCollect.testcollect.op1).Select(c => c.audioPath).FirstOrDefault(),
                 Op2Audio = db.People.Where(c => c.id == testCollect.testcollect.op2).Select(c => c.audioPath).FirstOrDefault(),
                 Op3Audio = db.People.Where(c => c.id == testCollect.testcollect.op3).Select(c => c.audioPath).FirstOrDefault(),
                 AssigningUserId = testCollect.app.appointment.appoint.userId
             });
            return Request.CreateResponse(HttpStatusCode.OK, data);
        }
        [HttpGet]
        public HttpResponseMessage GetPersonPracticeDetail(int practiceId)
        {
            var data = db.PersonPractices.Where(e => e.id == practiceId)
                .Join(db.PersonPracticCollections, personprac => personprac.id, personPracColl => personPracColl.personPractice, (personPrac, personPracColl) => new { personPrac, personPracColl })
                .Join(db.People, personpraccoll => personpraccoll.personPracColl.personId, person => person.id, (PersonPracColl, person) => new { PersonPracColl, person })
                .Join(db.PersonPictures, person => person.person.id, personpics => personpics.personid, (PersonPracColl, personpics) => new
                {
                    PersonPracColl.person.name,
                    PersonPracColl.person.audioPath,
                    PersonPracColl.person.id,

                    PersonPracColl.person.relation,
                    personpics.imgPath,

                }).Distinct();

            return Request.CreateResponse(HttpStatusCode.OK, data);




        }
        [HttpPost]
        public HttpResponseMessage TestComputation(List<TestResultComputation> AssignTestData)
        {

            try
            {
                string responce = "";
                if (AssignTestData.Count == 1)
                {
                    responce = computePersonTestResult(AssignTestData[0]);
                }
                else
                {
                    for (int i = 1; i < AssignTestData.Count; i++)
                    {
                        responce = computePersonTestResult(AssignTestData[0]);
                        responce += computePersonTestResult(AssignTestData[i]);
                    }
                }

                return Request.CreateResponse(HttpStatusCode.OK, responce);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.OK, ex.Message);
            }
        }
        private string computePersonTestResult(TestResultComputation AssignTestData)
        {
            var check = db.PersonIdentificationFeedbacks.Where(e => e.AppointmentId == AssignTestData.AppointmentId).ToList();
            if (check.Any())
            {
                return "Already Submited ";
            }
            int appointId = AssignTestData.AppointmentId;
            var data = db.AppointmentPersonTests.Where(e => e.appointmentId == appointId)
                .Join(db.PersonTests, apptest => apptest.personTestId, test => test.id, (apptest, test) => new { apptest, test })
                .Join(db.PersonTestCollections, test => test.test.id, testcolect => testcolect.personTestId, (apptestTest, testCollect) => new { apptestTest, testCollect })
                .Join(db.People, testCollect => testCollect.testCollect.personId, collect => collect.id, (testColl, coll) => new
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
            List<PersonIdentificationFeedback> patientTestCollectionFeedback = new List<PersonIdentificationFeedback>();

            count = 0;
            foreach (var item in data)
            {
                PersonIdentificationFeedback p = new PersonIdentificationFeedback();
                p.patientId = AssignTestData.Pid;
                p.personTestCollectionId = item.id;
                p.personId = item.collectId;
                p.feedback = result[count];
                p.AppointmentId = AssignTestData.AppointmentId;
                patientTestCollectionFeedback.Add(p);

                count++;
            }
            db.PersonIdentificationFeedbacks.AddRange(patientTestCollectionFeedback);
            db.SaveChanges();
            return "Submit Successfullt";
        }
        [HttpGet]
        public HttpResponseMessage GetAssignPersonPractice(int Pid)
        {
            var data = db.Patients
             .Where(e => e.pid == Pid)
             .Join(db.Appointments, p => p.pid, ap => ap.patientId, (patien, appoint) => new { patien, appoint })
             .Join(db.AppointmentPersonPractices, p => p.appoint.id, c => c.appointmentId, (appointment, appointTest) => new { appointment, appointTest })
             .Join(db.PersonPracticCollections, ap => ap.appointTest.personPracticeId, tc => tc.personPractice, (app, testcollect) => new { app, testcollect })
             .Join(db.People, test => test.testcollect.personId, c => c.id, (testCollect, collect) => new
             {
                 AppointmentDate = testCollect.app.appointment.appoint.appointmentDate,
                 AppointmentId = testCollect.app.appointment.appoint.id,
                 testCollectionID = testCollect.testcollect.id,
                 CollectId = collect.id,
                 Path = collect.picPath,
                 Name = collect.name,
                 collectAudio = collect.audioPath,
             });
            return Request.CreateResponse(HttpStatusCode.OK, data);
        }
        [HttpPost]
        public HttpResponseMessage AddPersonTest(PersonTestInfo info)
        {
            db.PersonTests.Add(info.Test);
            db.SaveChanges();
            foreach (var item in info.Persons)
            {
                item.personTestId = info.Test.id;
            }
            db.PersonTestCollections.AddRange(info.Persons);

            db.SaveChanges();
            return Request.CreateErrorResponse(HttpStatusCode.OK, "test Added");
        }
        [HttpGet]
        public HttpResponseMessage GetPersonTest(int uid)
        {
            var data = db.PersonTests.Where(e => e.createdBy == uid)
                .Join(db.PersonTestCollections, personTest => personTest.id, personTestColl => personTestColl.personTestId, (personTest, personTestColl) => new { personTest, personTestColl })
                .Join(db.People, ptPtc => ptPtc.personTestColl.personId, person => person.id, (ptPtc, person) => new
                {
                    Id = person.id,

                    EText = person.name,

                    PicPath = person.picPath,

                    QuestionTitle = ptPtc.personTestColl.questionTitle,
                    //  QuestionTitle = ptPtc.personTestColl.questionTitle,
                    Op1 = ptPtc.personTestColl.op1,
                    Op2 = ptPtc.personTestColl.op2,
                    Op3 = ptPtc.personTestColl.op3,
                    Title = ptPtc.personTest.title,
                    TestId = ptPtc.personTest.id,
                    Op1ImagePath = db.People.Where(c => c.id == ptPtc.personTestColl.op1).Select(c => c.picPath).FirstOrDefault(),
                    Op2ImagePath = db.People.Where(c => c.id == ptPtc.personTestColl.op2).Select(c => c.picPath).FirstOrDefault(),
                    Op3ImagePath = db.People.Where(c => c.id == ptPtc.personTestColl.op3).Select(c => c.picPath).FirstOrDefault(),

                }).ToList();
            return Request.CreateResponse(HttpStatusCode.OK, data);
        }
        [HttpPost]
        public HttpResponseMessage UploadPersonDatas()
        {
            try
            {
                var request = HttpContext.Current.Request;
                var name = request["name"];
                var gender = request["gender"];
                var age = int.Parse(request["age"]);
                var relation = request["relation"];
                var nameAudio = request.Files["audio"];
                var namePic = request.Files["picture"];
                var caregiverId = int.Parse(request["addBy"]);

                Person p = new Person();
                p.name = name;
                p.age = age;
                p.gender = gender;
                p.relation = relation;
                p.addBy = caregiverId;

                var id = db.People.OrderByDescending(x => x.id).Select(x => x.id).FirstOrDefault();


                if (nameAudio != null && nameAudio.ContentLength > 0)
                {
                    string audioFileName = $"{id + 1}.{nameAudio.FileName.Split('.')[1]}";
                    nameAudio.SaveAs(HttpContext.Current.Server.MapPath("~/Media/Person/audio/" + audioFileName));
                    p.audioPath = "C:\\Users\\us\\source\\LearnSpaceApi\\LearnSpaceApi\\Media\\Person\\audio\\" + audioFileName;
                }
                if (namePic != null && namePic.ContentLength > 0)
                {
                    string picfileName = $"{id + 1}.{namePic.FileName.Split('.')[1]}";
                    namePic.SaveAs(HttpContext.Current.Server.MapPath("~/Media/Person/Images/" + picfileName));
                    p.picPath = "C:\\Users\\us\\source\\LearnSpaceApi\\LearnSpaceApi\\Media\\Person\\Images\\" + picfileName;
                }
                db.People.Add(p);
                db.SaveChanges();

                return Request.CreateResponse(HttpStatusCode.OK, "inserted");
            }
            catch (Exception e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, e.Message);
            }
        }
    }
}
