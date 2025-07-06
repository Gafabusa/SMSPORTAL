using Microsoft.Practices.EnterpriseLibrary.Data;
using SmsPortalClassLibrary.EntityObjects;
using System;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;

namespace SmsPortalClassLibrary.ControlObjects
{
    public class DatabaseHelper
    {
        private Database db;
        private DbCommand cmd;

        public DatabaseHelper()
        {
            DatabaseProviderFactory factory = new DatabaseProviderFactory();
            db = factory.Create("SMSPORTAL22");
        }                         
        //authenticate systemoperator 
        public DataTable AuthenticateSystemOperator(string email, byte[] passwordHash)
        {
            var cmd = db.GetStoredProcCommand("sp_AuthenticateSystemOperator", new object[] { email, passwordHash });
            var ds = db.ExecuteDataSet(cmd);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                return ds.Tables[0];
            }

            return null;
        }
        //create vendoradmin
        public string CreateVendorAdmin(string vendorName, string userName, string email, byte[] passwordHash)
        {
            var cmd = db.GetStoredProcCommand("sp_CreateVendorAdmin");           
            db.AddInParameter(cmd, "@PasswordHash", DbType.Binary, passwordHash); 
            db.AddInParameter(cmd, "@VendorName", DbType.String, vendorName);
            db.AddInParameter(cmd, "@UserName", DbType.String, userName);
            db.AddInParameter(cmd, "@Email", DbType.String, email);
            db.AddOutParameter(cmd, "@ResultMessage", DbType.String, 250);

            db.ExecuteNonQuery(cmd);

            return db.GetParameterValue(cmd, "@ResultMessage").ToString();
        }

        //authenticate vendoradmin
        public DataTable AuthenticateVendorAdmin(string email, byte[] passwordHash)
        {
            var cmd = db.GetStoredProcCommand("sp_AuthenticateVendorAdmin");
            string passwordHashHex = BitConverter.ToString(passwordHash).Replace("-", "");


            db.AddInParameter(cmd, "@Email", DbType.String, email);
            db.AddInParameter(cmd, "@PasswordHash", DbType.Binary, passwordHash);


            var ds = db.ExecuteDataSet(cmd);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                return ds.Tables[0];
            }

            return null;
        }

        //create vendor user
        public string CreateVendorUser(string vendorName, string username, string email, byte[] passwordHash)
        {
            var cmd = db.GetStoredProcCommand("sp_CreateVendorUser");
          

            db.AddInParameter(cmd, "@VendorName", DbType.String, vendorName);
            db.AddInParameter(cmd, "@Username", DbType.String, username);
            db.AddInParameter(cmd, "@Email", DbType.String, email);
            db.AddInParameter(cmd, "@PasswordHash", DbType.Binary, passwordHash);
            db.AddOutParameter(cmd, "@ResultMessage", DbType.String, 250);

            db.ExecuteNonQuery(cmd);

            return db.GetParameterValue(cmd, "@ResultMessage").ToString();
        }

        //validating vendor user credentials
        public DataTable ValidateVendorUserByEmail(string email, byte[] passwordHash)
        {
            var cmd = db.GetStoredProcCommand("sp_ValidateVendorUserByEmail");

            string passwordHashHex = BitConverter.ToString(passwordHash).Replace("-", "");
            db.AddInParameter(cmd, "@Email", DbType.String, email);
            db.AddInParameter(cmd, "@PasswordHash", DbType.Binary, passwordHash);

            var ds = db.ExecuteDataSet(cmd);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                return ds.Tables[0];
            }

            return null;
        }
        // Get all vendor admins
        public DataTable GetAllVendorAdmins()
        {
            var cmd = db.GetStoredProcCommand("sp_GetAllVendorAdmins");
            return db.ExecuteDataSet(cmd).Tables[0];
        }

        // Delete vendor admin
        public void DeleteVendorAdmin(int vendorId)
        {
            var cmd = db.GetStoredProcCommand("sp_DeleteVendorAdmin");
            db.AddInParameter(cmd, "@VendorID", DbType.Int32, vendorId);
            db.ExecuteNonQuery(cmd);
        }

        // Unlock vendor admin
        public void UnlockVendorAdmin(int vendorId)
        {
            var cmd = db.GetStoredProcCommand("sp_UnlockVendorAdmin");
            db.AddInParameter(cmd, "@VendorID", DbType.Int32, vendorId);
            db.ExecuteNonQuery(cmd);
        }

        // Get vendor admin by ID
        public DataTable GetVendorAdminById(int vendorId)
        {
            var cmd = db.GetStoredProcCommand("sp_GetVendorAdminById");
            db.AddInParameter(cmd, "@VendorID", DbType.Int32, vendorId);
            return db.ExecuteDataSet(cmd).Tables[0];
        }

        // Update vendor admin details
        public void UpdateVendorAdmin(int vendorId, string vendorName, string userName, string email)
        {
            var cmd = db.GetStoredProcCommand("sp_UpdateVendorAdmin");
            db.AddInParameter(cmd, "@VendorID", DbType.Int32, vendorId);
            db.AddInParameter(cmd, "@VendorName", DbType.String, vendorName);
            db.AddInParameter(cmd, "@UserName", DbType.String, userName);
            db.AddInParameter(cmd, "@Email", DbType.String, email);
            db.ExecuteNonQuery(cmd);
        }
        //check for duplicate vendor admin email and username
        public string CheckDuplicateVendor(string vendorName, string email)
        {
            string result = "OK";

            using (DbCommand cmd = db.GetStoredProcCommand("sp_CheckDuplicateVendorAdmin"))
            {
                db.AddInParameter(cmd, "@VendorName", DbType.String, vendorName);
                db.AddInParameter(cmd, "@Email", DbType.String, email);

                using (IDataReader reader = db.ExecuteReader(cmd))
                {
                    if (reader.Read())
                    {
                        result = reader["Result"].ToString();
                    }
                }
            }

            return result;
        }
        // Check for duplicate vendor user email and username
        public string CheckDuplicateVendorUser(string username, string email)
        {
            string result = "Available";

            using (DbCommand cmd = db.GetStoredProcCommand("sp_CheckDuplicateVendorUser"))
            {
                db.AddInParameter(cmd, "@Username", DbType.String, username);
                db.AddInParameter(cmd, "@Email", DbType.String, email);

                using (IDataReader reader = db.ExecuteReader(cmd))
                {
                    if (reader.Read())
                    {
                        result = reader["Result"].ToString();
                    }
                }
            }

            return result;
        }



    }
}
