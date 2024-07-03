using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LearnSpaceApi.Models
{
    public class PatientPerformTestModel 
    {
        public int TestId { get; set; }
        public int aptId { get; set; }
        public List<PatientPerformTest> Collections { get; set; }
    }
    public class PatientPerformTest
    {
        public string UserType { get; set; }
        public DateTime AppointmentDate { get; set; }
        public int AppointmentId { get; set; }
        public int testCollectionID { get; set; }
        public string Path { get; set; }
        public string Etext { get; set; }
        public string Utext { get; set; }
        public string Group { get; set; }
        public string Type { get; set; }
        public int CollectId { get; set; }
        public int Opt1 { get; set; }
        public int Opt2 { get; set; }
        public int Opt3 { get; set; }
        public string Opt1eText { get; set; }
        public string Opt2eText { get; set; }
        public string Opt3eText { get; set; }
        public string Op1ImagePath { get; set; }
        public string Op2ImagePath { get; set; }
        public string Op3ImagePath { get; set; }
        public string Question { get; set; }
        public string collectAudio { get; set; }
        public string Op1Audio { get; set; }
        public string Op2Audio { get; set; }
        public string Op3Audio { get; set; }

    }
}