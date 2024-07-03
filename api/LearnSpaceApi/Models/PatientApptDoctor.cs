using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LearnSpaceApi.Models
{
    public class PatientApptDoctor
    {
        public Appointment appointment { get; set; }
        public string name { get; set; }
        public List<AppointmentPractice> appointmentPractices { get; set; }
        public List<AppointmentTest> appointmentTests { get; set; }
    }
}