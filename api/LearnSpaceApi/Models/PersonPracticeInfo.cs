﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LearnSpaceApi.Models
{
    public class PersonPracticeInfo
    {
        public PersonPractice PersonPractice { get; set; }
        public List<PersonPracticCollection> Persons { get; set; }
    }
}