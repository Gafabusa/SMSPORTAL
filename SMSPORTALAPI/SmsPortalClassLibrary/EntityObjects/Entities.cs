using System;

namespace SmsPortalClassLibrary.EntityObjects
{
    public class Vendor
    {
        public int VendorID { get; set; }
        public string VendorName { get; set; }
        public int Credits { get; set; }
        public DateTime CreatedOn { get; set; }

        // For user creation
        public string UserName { get; set; }
        public byte[] PasswordHash { get; set; }
        public string VendorEmail { get; set; }
        public int UserLimit { get; set; }
    }

    public class VendorUser
    {
        public int UserID { get; set; }
        public int VendorID { get; set; }
        public string Username { get; set; }
        public byte[] PasswordHash { get; set; }
        public string Role { get; set; }
        public bool IsActive { get; set; }
        public int FailedLoginAttempts { get; set; }
        public bool Locked { get; set; }
        public DateTime CreatedOn { get; set; }

        // Extra fields
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public string VendorName { get; set; }
        public string AccountStatus { get; set; }
    }

    public class SMSFileUpload
    {
        public int FileID { get; set; }
        public int VendorID { get; set; }
        public int UploadedBy { get; set; }
        public string Message { get; set; }
        public string FilePath { get; set; }
        public bool IsTemplate { get; set; }
        public bool IsScheduled { get; set; }
        public DateTime? ScheduledStartTime { get; set; }
        public DateTime UploadedAt { get; set; }
        public string Status { get; set; }
        public bool Processed { get; set; }
        public DateTime? ProcessedDate { get; set; }
    }

    public class PortalSMSInbox
    {
        public int SMSID { get; set; }
        public int FileUploadID { get; set; }
        public string Message { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string Status { get; set; }
        public DateTime CreatedOn { get; set; }
        public bool Sent { get; set; }
        public DateTime? SentDate { get; set; }
        public Guid VendorTranID { get; set; }
    }

    public class PortalSMSQueue
    {
        public int QueueID { get; set; }
        public int SMSID { get; set; }
        public DateTime EnqueuedAt { get; set; }
    }

    public class PortalSMSOutboxCompleted
    {
        public int OutboxID { get; set; }
        public int SMSID { get; set; }
        public string Message { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public DateTime SentDate { get; set; }
        public Guid VendorTranID { get; set; }
    }

    public class SMSFileUploadReport
    {
        public int ReportID { get; set; }
        public int FileID { get; set; }
        public string SuccessFilePath { get; set; }
        public string FailedFilePath { get; set; }
        public DateTime ReportGeneratedOn { get; set; }
    }

    public class AuditTrail
    {
        public int AuditID { get; set; }
        public int UserID { get; set; }
        public string Action { get; set; }
        public DateTime ActionTime { get; set; }
        public string Outcome { get; set; }
    }

    public class SmsQueueItem
    {
        public int Id { get; set; }
        public string Message { get; set; }
        public int FileUploadId { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string Status { get; set; }
        public DateTime CreatedOn { get; set; }
        public bool Sent { get; set; }
        public Guid VendorTranId { get; set; }
    }
    public class SystemOperator
    {
        public int OperatorID { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public byte[] PasswordHash { get; set; }
        public DateTime CreatedOn { get; set; }
    }

}
