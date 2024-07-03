 using LearnSpaceApi.Models;
using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net;
using System.Web;
using System.Web.Http;
//using System.Web.Mvc;

namespace LearnSpaceApi.Controllers
{
    public class CollectionController : ApiController
    {

        slowlearnerDataBaseEntities db = new slowlearnerDataBaseEntities();

        [HttpPost]
        public HttpResponseMessage AddColletion()
        {
            try
            {
                var request = HttpContext.Current.Request;
                var Utext = request["utext"];
                var Etext = request["etext"];
                var validation = db.Collections.Where(e => e.eText == Etext || e.uText == Utext);
                if (validation.Any())
                {
                    return Request.CreateResponse(HttpStatusCode.OK, "Data already exist");
                }
                var Type = request["type"];
                var group = request["group"];
                var Picture = request.Files["picture"];
                var Audio = request.Files["audio"];
                string picfileName = Etext + "." + Picture.FileName.Split('.')[1];
                Picture.SaveAs(HttpContext.Current.Server.MapPath("~/Media/Alphabets/Images/" + picfileName));
                string audiofileName = Etext + "." + Audio.FileName.Split('.')[1];
                Audio.SaveAs(HttpContext.Current.Server.MapPath("~/Media/Alphabets/audios/" + audiofileName));
                Collection c = new Collection();
                c.uText = Utext;
                c.eText = Etext;
                c.type = Type;
                c.C_group = group;
                c.audioPath = "C:\\Users\\us\\source\\LearnSpaceApi\\LearnSpaceApi\\Media\\Alphabets\\audios\\" + audiofileName;
                c.picPath = "C:\\Users\\us\\source\\LearnSpaceApi\\LearnSpaceApi\\Media\\Alphabets\\Images\\" + picfileName;
                db.Collections.Add(c);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Collection has been added successfully");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.OK, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage allCollections(string type)
        {
            try
            {
                List<collect> cllist = new List<collect>();
                var col = db.Collections.Where(e => e.type == type).Select(c => new { c.id, c.picPath, c.uText, c.eText, c.type, c.C_group, c.audioPath }).ToList();
                foreach (Collection c in db.Collections)
                {
                    if (c.type == type)
                    {
                        collect co = new collect();
                        co.id = c.id;
                        co.uText = c.uText;
                        co.eText = c.eText;
                        co.type = c.type;
                        co.C_group = c.C_group;
                        byte[] imageBytes = File.ReadAllBytes(c.picPath);
                        co.picPath = Convert.ToBase64String(imageBytes);
                        byte[] audioBytes = File.ReadAllBytes(c.audioPath);
                        co.audio = Convert.ToBase64String(audioBytes);
                        cllist.Add(co);
                    }
                }


                return Request.CreateResponse(HttpStatusCode.OK, cllist);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        //Currently not in use: we'll use it for test creation on front end when we wish to filter by groups also
        [HttpGet]
        public HttpResponseMessage allSubjectToTypeandGroup(string type,string cgroup)
        {
            try
            {
                List<collect> cllist = new List<collect>();
                var col = db.Collections.Where(e => e.type == type&&e.C_group==cgroup).Select(c => new { c.id, c.picPath, c.uText, c.eText, c.type, c.C_group, c.audioPath }).ToList();
                foreach (Collection c in db.Collections)
                {
                    if (c.type == type)
                    {
                        collect co = new collect();
                        co.id = c.id;
                        co.uText = c.uText;
                        co.eText = c.eText;
                        co.type = c.type;
                        co.C_group = c.C_group;
                        byte[] imageBytes = File.ReadAllBytes(c.picPath);
                        co.picPath = Convert.ToBase64String(imageBytes);
                        byte[] audioBytes = File.ReadAllBytes(c.audioPath);
                        co.audio = Convert.ToBase64String(audioBytes);
                        cllist.Add(co);
                    }
                }


                return Request.CreateResponse(HttpStatusCode.OK, cllist);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }

        }
    }
}class collect 
{
   public int id { get; set; }
    public string picPath { get; set; }
    public string uText { get; set; }
    public  string eText { get; set; }
    public string type { get; set; }
    public string C_group { get; set; }
    public string audio { get; set; }

}