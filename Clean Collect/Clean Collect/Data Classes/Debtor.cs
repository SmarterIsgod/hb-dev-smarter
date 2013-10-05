using System;
using System.Collections.Generic;

namespace Clean_Collect
{
    public class Debtor
    {
        public string Name;
        public Address Address;
        public Phone Phone;
        public int Age
        {
            get
            {
                var age = (DateTime.Now - DateOfBirth).Days/365;
                return (int) Math.Round((double) age, 0);
            }
        }

        public int SocialSecurityNumber;
        public string[] EMailAddresses;
        public DateTime DateOfBirth;
        public TimeZone TimeZone;
        public DriverLicence DriverLicence;
        public Employment Employment;
        public DateTime LastModified;

    }

    public class Address
    {
        public string Street;
        public int Zip;
        public string State;
        public string City;
        public string County;
        public DateTime LastModified;
    }
    public enum ResidenceType
    {
        Current,
        Previous,
        Possible
    }

    public class PhoneNumber
    {
        public int Number;
        public PhoneType Type;
        public string Notes;
        public DateTime LastModified;
    }

    public class Phone
    {
        public List<PhoneNumber> Personal;
        public List<PhoneNumber> Relative;
        public List<PhoneNumber> Reference;
        public DateTime LastModified;
    }

    public class Employment
    {
        public List<Employer> Employers;
        public DateTime LastModified;
    }

    public class Employer
    {
        public string Name;
        public string Phone;
        public double Wage;
        public string Title;
        public PayFrequency PayFrequency;
        public DateTime HireDate;
        public TimeSpan TimeEmployed
        {
            get { return new TimeSpan((DateTime.Now - HireDate).Days/365);}
        }
        public DateTime LastModified;
    }

    public enum PayFrequency
    {
        Weekly,
        BiWeekly,
        Monthly
    }

    public class DriverLicence
    {
        public int Id;
        public string State;
        public DateTime Expiration;
        public DateTime LastModified;
        private string _imageFile;
    }

    public enum TimeZone
    {
        Eastern,
        Central,
        Pacific,
        Mountain
    }

    public enum PhoneType
    {
        Home,
        Work,
        Mobile
    }
}
