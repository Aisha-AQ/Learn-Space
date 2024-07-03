using LearnSpaceApi.Models;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Web;
using System.Web.Http;
using System.Web.UI;

namespace LearnSpaceApi.Controllers
{
    
    public class PracticeController : ApiController
    {
        slowlearnerDataBaseEntities db = new slowlearnerDataBaseEntities();
        [HttpPost]
        public HttpResponseMessage AddNewPractice(PracticeInfo info)
        {

            try {
                db.Practices.Add(info.practice);
                db.SaveChanges();
                 

                foreach (var item in info.collections)
                {
                    item.pracId = info.practice.id;
                }
                db.PracticeCollections.AddRange(info.collections);
                db.SaveChanges();
                return Request.CreateErrorResponse(HttpStatusCode.OK, "data saved");
            }catch(Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError,ex.Message);
            }
            }

        [HttpGet]
        public HttpResponseMessage userDefindPractices(int Uid)
        {
            var data = db.Practices.Where(e => e.createBy == Uid)
                .Join(db.PracticeCollections, practic => practic.id, pracCollection => pracCollection.pracId, (practic, pracCollection) => new { practic, pracCollection })
                .Join(db.Collections, ppc => ppc.pracCollection.collectId, collect => collect.id, (ppc, collect) => new
                {
                    ppc.practic.id,
                    ppc.practic.title,
                    ppc.practic.stage,
                    ppc.practic.assignedFlag,
                    collect.uText,
                    collect.eText,
                    collect.type,
                    collect.picPath,
                    collect.C_group,
                    collect.audioPath

                });

            if (data.Any())
            {

                return Request.CreateResponse(HttpStatusCode.OK, data);
            }
            return Request.CreateResponse(HttpStatusCode.NotFound, "data not found");
        }
        [HttpPost]
        public HttpResponseMessage addAppointment(PatientAppointment pa) 
        {
            try
            {
                bool appointmentCreated=false;
                if (pa.appointmentPractices != null && pa.appointmentPractices.Count != 0)
                {
                    //check if practice is already currently assigned
                    foreach (var item in pa.appointmentPractices)
                    {
                        var duplication= db.AppointmentPractices.Where(e => e.practiceId == item.practiceId).Join(db.Appointments, ap => ap.appointmentId, appointments => appointments.id, (ap, appointments) => new { appointments.nextAppointDate}).ToList();
                        if (duplication.Any()) 
                        {
                            foreach(var v in duplication) 
                            {
                                int compareDate = DateTime.Compare(v.nextAppointDate, DateTime.Now);
                                //next appointment date is greater than current date or if it is same day
                                if(compareDate > 0||compareDate==0) 
                                {
                                    Practice pr=db.Practices.Where(ex=>ex.id==item.practiceId).FirstOrDefault();
                                    return Request.CreateResponse(HttpStatusCode.Conflict, pr.title+" is already assigned");
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
                        var PracticeFlagToUpdate = db.Practices.FirstOrDefault(p=>p.id==item.practiceId);
                        if (PracticeFlagToUpdate != null)
                        {
                            PracticeFlagToUpdate.assignedFlag = 1;
                        }
                    }
                    db.AppointmentPractices.AddRange(pa.appointmentPractices);
                    
                }
                if (pa.appointmentTests != null && pa.appointmentTests.Count!=0)
                {
                    if (!appointmentCreated) 
                    {
                        db.Appointments.Add(pa.appointment);
                        db.SaveChanges();
                    }
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
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "Error "+ex.InnerException);
            }
        }
        [HttpPost]
        public HttpResponseMessage addAppointmentDoctor(PatientApptDoctor pa)
        {
            try
            {
                bool appointmentCreated = false;
                var patietExists=db.Patients.Where(p => p.userName == pa.name).FirstOrDefault();
                if(patietExists == null)
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound, "Patients' username is incorrect.");
                }
                else
                {
                    pa.appointment.patientId = patietExists.pid;
                }
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
                                    return Request.CreateResponse(HttpStatusCode.Conflict, pr.title + " is already currently assigned");
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
                if (!appointmentCreated) 
                {
                    db.Appointments.Add(pa.appointment);
                    db.SaveChanges();
                }
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Appointment added successfully");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "Error " + ex.InnerException);
            }
        }
    }
}
