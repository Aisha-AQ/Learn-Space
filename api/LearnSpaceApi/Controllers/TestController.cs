using LearnSpaceApi.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace LearnSpaceApi.Controllers
{
    public class TestController : ApiController
    {
        slowlearnerDataBaseEntities db = new slowlearnerDataBaseEntities();
        public HttpResponseMessage AddNewTest(TestInfo info)
        {

            db.Tests.Add(info.test);
            db.SaveChanges();
            foreach (var item in info.collectionsIds)
            {
                item.testId = info.test.id;
            }
            db.TestCollections.AddRange(info.collectionsIds);

            db.SaveChanges();
            return new HttpResponseMessage(HttpStatusCode.OK);
        }
        [HttpGet]
        public HttpResponseMessage userDefindTest(int Uid)
        {
            var data = db.Tests.Where(e => e.createBy == Uid)
                .Join(db.TestCollections, test => test.id, testCollection => testCollection.testId, (test, testCollection) => new { test, testCollection })
                .Join(db.Collections, ttc => ttc.testCollection.collectId, collect => collect.id, (ppc, collect) => new
                {
                    /*
                                        collect.id,*/
                    collect.uText,
                    collect.eText,
                    collect.type,
                    collect.picPath,
                    collect.C_group,
                    collect.audioPath,
                    ppc.testCollection.op1,
                    ppc.testCollection.op2,
                    ppc.testCollection.op3,
                    ppc.test.id,
                    ppc.test.title,
                    ppc.test.createBy,
                    ppc.test.stage

                });

            if (data.Any())
            {

                return Request.CreateResponse(HttpStatusCode.OK, data);
            }
            return Request.CreateResponse(HttpStatusCode.Conflict, "data not fornd");
        }
        [HttpGet]
        public HttpResponseMessage showSpacificAppointmentData(int AppointmentId, int pid)
        {
            var TestData = db.PatientTestCollectionFeedbacks.Where(e => e.AppointmentId == AppointmentId && e.patientId == pid)
                /*.Join(db.AppointmentTest, appoint => appoint.id, AppointmentTest => AppointmentTest.appointmentId, (appoint, appointmentTest) => new { appoint, appointmentTest })
                .Join(db.TestCollection, appointtest => appointtest.appointmentTest.testId, testcollection => testcollection.testId, (appoint, testcollection) => new { appoint, testcollection }).
                Join(db.PatientTestCollectionFeedback, ttc => ttc.testcollection.id, ptcf => ptcf.id, (appointTestCollection, pTestColletFedback) => new { appointTestCollection, pTestColletFedback })*/
                .Join(db.Collections, ptcf => ptcf.collectionId, collect => collect.id, (Ptch, collect) => new
                {
                    collect.eText,
                    collect.uText,
                    collect.type,
                    Ptch.feedback,


                });
            var PracticeData = db.Appointments.Where(e => e.id == AppointmentId && e.patientId == pid)
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
            var result = new { uid, TestData };

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }
    }
}