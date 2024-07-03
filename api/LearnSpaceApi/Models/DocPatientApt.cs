using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LearnSpaceApi.Models
{
    public class DocPatientApt
    {
        public Appointment appointment { get; set; }
        public Patient patients { get; set; }
    }
}