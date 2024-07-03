using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LearnSpaceApi.Models
{
    public class PatientPracticeData
    {

        public string title { get;set; }
        public int appointmentId { get; set; }
        public DateTime AppointmentDate { get; set; }
        public int practiceCollectionId { get; set; }
        public int pracId { get; set; }
        public int id { get; set; }
        public string audioPath { get; set; }
        public string picPath { get; set; }

        public string eText { get; set; }
        public string uText { get; set; }
        public string C_group { get; set; }
        public string type { get; set; }
       
    }
}