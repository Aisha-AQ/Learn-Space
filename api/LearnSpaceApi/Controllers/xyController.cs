using LearnSpaceApi.Models;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Runtime.Remoting.Messaging;
using System.Web;
using System.Web.Http;

namespace LearnSpaceApi.Controllers
{
    public class xyController : ApiController
    {
        slowlearnerDataBaseEntities db = new slowlearnerDataBaseEntities();
        [HttpPost]
        public HttpResponseMessage UploadPersonData(int forceAdd)
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

                if (forceAdd==0)
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

                var id=db.People.OrderByDescending(x => x.id).Select(x=>x.id).FirstOrDefault();
                

                if (nameAudio != null && nameAudio.ContentLength > 0)
                {
                    string audioFileName = $"{id+1}.{nameAudio.FileName.Split('.')[1]}";
                    nameAudio.SaveAs(HttpContext.Current.Server.MapPath("~/Media/Person/audio/" + audioFileName));
                    p.audioPath = "C:\\Users\\us\\source\\LearnSpaceApi\\LearnSpaceApi\\Media\\Person\\audio\\" + audioFileName;
                }
                if (namePic != null && namePic.ContentLength > 0)
                {
                    string picfileName = $"{id+1}.{namePic.FileName.Split('.')[1]}";
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
        public HttpResponseMessage AddNewTest(TestInfo info)
        {
            try
            {
                var exists = db.Tests.Where(x => x.title == info.test.title&&x.createBy==info.test.createBy).FirstOrDefault();
                if (exists != null)
                {
                    return Request.CreateErrorResponse(HttpStatusCode.NotAcceptable, "The title already exists");
                }
                db.Tests.Add(info.test);

                db.SaveChanges();
                foreach (var item in info.collectionsIds)
                {
                    item.testId = info.test.id;
                }
                db.TestCollections.AddRange(info.collectionsIds);

                db.SaveChanges();
                return new HttpResponseMessage(HttpStatusCode.OK);
            }catch(Exception ex) 
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError,ex.Message+ex.InnerException.ToString());
            }
        }
        [HttpPost]
        public HttpResponseMessage addAppointment(PatientAppointment pa)
        {
            try
            {
                db.Appointments.Add(pa.appointment);
                db.SaveChanges();
                if (pa.appointmentPractices != null)
                {
                    foreach (var item in pa.appointmentPractices)
                    {
                        item.appointmentId = pa.appointment.id;
                    }
                    db.AppointmentPractices.AddRange(pa.appointmentPractices);
                }
                if (pa.appointmentTests != null)
                {
                    foreach (var item in pa.appointmentTests)
                    {
                        item.appointmentId = pa.appointment.id;
                    }
                    db.AppointmentTests.AddRange(pa.appointmentTests);
                }
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Appointment added successfully");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "Error \n" + ex.Message);
            }
        }
    }
}