using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LearnSpaceApi.Models
{
    public class PatientAppointment
    {
        public Appointment appointment { get; set; }
        public List<AppointmentPractice> appointmentPractices { get; set; }
        public List<AppointmentTest> appointmentTests { get; set; }
        public List<AppointmentPersonPractice> AppointmentPersonPractice { get; set; }
        public List<AppointmentPersonTest> AppointmentPersonTest { get; set; }
    }
}