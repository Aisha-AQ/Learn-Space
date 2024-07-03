using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace LearnSpaceApi.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {//mk
            ViewBag.Title = "Home Page";

            return View();
        }
    }
}
