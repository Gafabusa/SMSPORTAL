using log4net;
using SmsPortalClassLibrary.ControlObjects;
using SmsPortalClassLibrary.EntityObjects;
using System;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Web.Services;


namespace SMSPORTALAPI
{
    [WebService(Namespace = "http://smsportalapi.com/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class SmsportalApi : WebService
    {
        BusinessLogic logic = new BusinessLogic();
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
     
        
        //authenticate system operator
        [WebMethod]
        public DataTable LoginSystemOperator(string email, byte[] passwordHash)
        {
            BusinessLogic bl = new BusinessLogic();
            DataTable result = bl.AuthenticateSystemOperator(email, passwordHash);
            return result;
        }
        //creating vendoradmin
        [WebMethod]
        public void sp_CreateVendorAdmin(string vendorName, string userName, string email, string password)
        {
            try
            {
                log.Info($"Starting sp_CreateVendorAdmin for vendorName={vendorName}, email={email}");

                // Validate password: must be at least 6 characters, contain letters and numbers
                if (string.IsNullOrWhiteSpace(password) || password.Length < 6 ||
                    !password.Any(char.IsDigit) || !password.Any(char.IsLetter))
                {
                    throw new Exception("Password must be at least 6 characters long and include both letters and numbers.");
                }

                // Hash password
                byte[] passwordHash = ComputeHash(password);

                // Call business logic
                string resultMessage = logic.CreateVendorAdmin(vendorName, userName, email, passwordHash);

                log.Info($"sp_CreateVendorAdmin result: {resultMessage}");
            }
            catch (Exception ex)
            {
                log.Error($"Error in sp_CreateVendorAdmin for email={email}", ex);
                throw;
            }
        }
        // authenticating vendoradmin
        [WebMethod]
        public DataTable LoginVendorAdmin(string email, byte[] passwordHash)
        {
            BusinessLogic bl = new BusinessLogic();
            return bl.AuthenticateVendorAdmin(email, passwordHash);
        }

        //create vendor user
        [WebMethod]
        public string CreateVendorUser(string vendorName, string username, string email, byte[] passwordHash)
        {
            BusinessLogic logic = new BusinessLogic();
            return logic.CreateVendorUser(vendorName, username, email, passwordHash);
        }
        //validate vendor user
        [WebMethod]
        public DataTable ValidateVendorUserByEmail(string email, byte[] passwordHash)
        {
            return logic.ValidateVendorUserByEmail(email, passwordHash);
        }
        //Get all vendoradmins
        [WebMethod]
        public DataTable GetAllVendorAdmins()
        {
            return logic.GetAllVendorAdmins();
        }
        //Deleting vendoradmins
        [WebMethod]
        public void DeleteVendorAdmin(int vendorId)
        {
            logic.DeleteVendorAdmin(vendorId);
        }
        //unlocking vendoradmins
        [WebMethod]
        public void UnlockVendorAdmin(int vendorId)
        {
            logic.UnlockVendorAdmin(vendorId);
        }
        //Grt vendoradmins by id
        [WebMethod]
        public DataTable GetVendorAdminById(int vendorId)
        {
            return logic.GetVendorAdminById(vendorId);
        }
        //Update vendoradmin details
        [WebMethod]
        public void UpdateVendorAdmin(int vendorId, string vendorName, string userName, string email)
        {
            logic.UpdateVendorAdmin(vendorId, vendorName, userName, email);
        }

        private static byte[] ComputeHash(string input)
        {
            using (SHA256 sha = SHA256.Create())
            {
                return sha.ComputeHash(Encoding.UTF8.GetBytes(input));
            }
        }
    }
}