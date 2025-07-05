using Microsoft.Practices.EnterpriseLibrary.Data;
using SmsPortalClassLibrary.ControlObjects;
using SmsPortalClassLibrary.EntityObjects;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.IO;

namespace SmsPortalClassLibrary.ControlObjects
{
    public class BusinessLogic
    {
        private DatabaseHelper db;

        public BusinessLogic()
        {
            db = new DatabaseHelper();
        }      
        
        //Authenticate system operator
        public DataTable AuthenticateSystemOperator(string email, byte[] passwordHash)
        {
            return db.AuthenticateSystemOperator(email, passwordHash);
        }
        //create vendoradmin
        public string CreateVendorAdmin(string vendorName, string userName, string email, byte[] passwordHash)
        {
            return db.CreateVendorAdmin(vendorName, userName, email, passwordHash);
        }

        //authenticate vendor admin
        public DataTable AuthenticateVendorAdmin(string email, byte[] passwordHash)
        {
            return db.AuthenticateVendorAdmin(email, passwordHash);
        }
        //create vendor user
        public string CreateVendorUser(string vendorName, string username, string email, byte[] passwordHash)
        {
            return db.CreateVendorUser(vendorName, username, email, passwordHash);
        }
        //validating vendor user
        public DataTable ValidateVendorUserByEmail(string email, byte[] passwordHash)
        {
            return db.ValidateVendorUserByEmail(email, passwordHash);
        }
        // Fetch all vendor admins
        public DataTable GetAllVendorAdmins()
        {
            return db.GetAllVendorAdmins();
        }

        // Delete vendor admin
        public void DeleteVendorAdmin(int vendorId)
        {
            db.DeleteVendorAdmin(vendorId);
        }

        // Unlock vendor admin
        public void UnlockVendorAdmin(int vendorId)
        {
            db.UnlockVendorAdmin(vendorId);
        }

        // Get vendor admin by ID
        public DataTable GetVendorAdminById(int vendorId)
        {
            return db.GetVendorAdminById(vendorId);
        }

        // Update vendor admin
        public void UpdateVendorAdmin(int vendorId, string vendorName, string userName, string email)
        {
            db.UpdateVendorAdmin(vendorId, vendorName, userName, email);
        }





    }
}
