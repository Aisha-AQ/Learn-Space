using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LearnSpaceApi.Models
{
    public class TestResultComputation
    {
        public List<int> SelectedOptions { get; set; }
        public int AppointmentId { get; set; }
        public int Pid { get; set; }
    }
}