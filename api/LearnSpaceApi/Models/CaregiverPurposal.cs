//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace LearnSpaceApi.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class CaregiverPurposal
    {
        public int id { get; set; }
        public Nullable<int> PatientId { get; set; }
        public Nullable<int> UserId { get; set; }
        public string Status { get; set; }
    
        public virtual Patient Patient { get; set; }
        public virtual User User { get; set; }
    }
}
