﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LearnSpaceApi.Models
{
    public class PracticeInfo
    {
        public Practice practice { get; set; }
        public List<PracticeCollection> collections { get; set; }
    }
}