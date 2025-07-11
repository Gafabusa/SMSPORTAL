USE [SMSPORTAL22]
GO
/****** Object:  Table [dbo].[AuditTrail]    Script Date: 07/07/2025 00:24:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditTrail](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[Action] [nvarchar](100) NULL,
	[ActionTime] [datetime] NULL,
	[Outcome] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PortalSMSInbox]    Script Date: 07/07/2025 00:24:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalSMSInbox](
	[SMSID] [int] IDENTITY(1,1) NOT NULL,
	[FileUploadID] [int] NULL,
	[Message] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[Email] [nvarchar](150) NULL,
	[Status] [nvarchar](20) NULL,
	[CreatedOn] [datetime] NULL,
	[Sent] [bit] NULL,
	[SentDate] [datetime] NULL,
	[VendorTranID] [uniqueidentifier] NULL,
PRIMARY KEY CLUSTERED 
(
	[SMSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PortalSMSOutboxCompleted]    Script Date: 07/07/2025 00:24:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalSMSOutboxCompleted](
	[OutboxID] [int] IDENTITY(1,1) NOT NULL,
	[SMSID] [int] NULL,
	[Message] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[Email] [nvarchar](150) NULL,
	[SentDate] [datetime] NULL,
	[VendorTranID] [uniqueidentifier] NULL,
PRIMARY KEY CLUSTERED 
(
	[OutboxID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PortalSMSQueue]    Script Date: 07/07/2025 00:24:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalSMSQueue](
	[QueueID] [int] IDENTITY(1,1) NOT NULL,
	[SMSID] [int] NULL,
	[EnqueuedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[QueueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SMSFileUpload]    Script Date: 07/07/2025 00:24:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMSFileUpload](
	[FileID] [int] IDENTITY(1,1) NOT NULL,
	[VendorID] [int] NULL,
	[UploadedBy] [int] NULL,
	[Message] [nvarchar](max) NULL,
	[FilePath] [nvarchar](500) NULL,
	[IsTemplate] [bit] NULL,
	[IsScheduled] [bit] NULL,
	[ScheduledStartTime] [datetime] NULL,
	[UploadedAt] [datetime] NULL,
	[Status] [nvarchar](20) NULL,
	[Processed] [bit] NULL,
	[ProcessedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[FileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SMSFileUploadReport]    Script Date: 07/07/2025 00:24:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMSFileUploadReport](
	[ReportID] [int] IDENTITY(1,1) NOT NULL,
	[FileID] [int] NULL,
	[SuccessFilePath] [nvarchar](500) NULL,
	[FailedFilePath] [nvarchar](500) NULL,
	[ReportGeneratedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SystemOperator]    Script Date: 07/07/2025 00:24:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemOperator](
	[OperatorID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[PasswordHash] [varbinary](64) NOT NULL,
	[CreatedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[OperatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendorTable]    Script Date: 07/07/2025 00:24:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendorTable](
	[VendorID] [int] IDENTITY(1,1) NOT NULL,
	[VendorName] [nvarchar](100) NOT NULL,
	[Credits] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[Email] [nvarchar](100) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[PasswordHash] [varbinary](32) NULL,
PRIMARY KEY CLUSTERED 
(
	[VendorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendorUser]    Script Date: 07/07/2025 00:24:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendorUser](
	[UserID] [int] IDENTITY(1000,1) NOT NULL,
	[VendorID] [int] NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Role] [nvarchar](20) NOT NULL,
	[IsActive] [bit] NULL,
	[FailedLoginAttempts] [int] NULL,
	[Locked] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[Email] [nvarchar](100) NOT NULL,
	[PasswordHash] [varbinary](64) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SystemOperator] ON 

INSERT [dbo].[SystemOperator] ([OperatorID], [Username], [Email], [PasswordHash], [CreatedOn]) VALUES (1, N'admin', N'admin@gmail.com', 0x240BE518FABD2724DDB6F04EEB1DA5967448D7E831C08C8FA822809F74C720A9, CAST(N'2025-06-30T07:51:42.507' AS DateTime))
SET IDENTITY_INSERT [dbo].[SystemOperator] OFF
GO
SET IDENTITY_INSERT [dbo].[VendorTable] ON 

INSERT [dbo].[VendorTable] ([VendorID], [VendorName], [Credits], [CreatedOn], [Email], [UserName], [PasswordHash]) VALUES (1006, N'DFCU', 0, CAST(N'2025-07-04T09:38:52.987' AS DateTime), N'dfcu@gmail.com', N'DFCU', 0x593A46A25E11B1DD12EB6D47B6A9E4B70169D896FA89C6C6DEBEF59A53DD8338)
INSERT [dbo].[VendorTable] ([VendorID], [VendorName], [Credits], [CreatedOn], [Email], [UserName], [PasswordHash]) VALUES (1007, N'WILLYTECH', 0, CAST(N'2025-07-04T11:22:02.073' AS DateTime), N'willytech80@gmail.com', N'WILLYTECH', 0x9787149886BCA1DAC9E5836E5030737EE5B5B9E3E72A5FEF6C282C37B04E1FD6)
INSERT [dbo].[VendorTable] ([VendorID], [VendorName], [Credits], [CreatedOn], [Email], [UserName], [PasswordHash]) VALUES (1008, N'Gafabusa', 0, CAST(N'2025-07-04T17:48:00.047' AS DateTime), N'willygafabusa@gmail.com', N'Gafs', 0x9787149886BCA1DAC9E5836E5030737EE5B5B9E3E72A5FEF6C282C37B04E1FD6)
INSERT [dbo].[VendorTable] ([VendorID], [VendorName], [Credits], [CreatedOn], [Email], [UserName], [PasswordHash]) VALUES (1009, N'AMOOTI', 0, CAST(N'2025-07-05T23:45:55.617' AS DateTime), N'willyamooti80@gmail.com', N'Amooti', 0x9787149886BCA1DAC9E5836E5030737EE5B5B9E3E72A5FEF6C282C37B04E1FD6)
INSERT [dbo].[VendorTable] ([VendorID], [VendorName], [Credits], [CreatedOn], [Email], [UserName], [PasswordHash]) VALUES (1012, N'Pcee Kcee', 0, CAST(N'2025-07-06T22:42:44.277' AS DateTime), N'amootiwilly80@gmail.com', N'Pcee', 0x9787149886BCA1DAC9E5836E5030737EE5B5B9E3E72A5FEF6C282C37B04E1FD6)
SET IDENTITY_INSERT [dbo].[VendorTable] OFF
GO
SET IDENTITY_INSERT [dbo].[VendorUser] ON 

INSERT [dbo].[VendorUser] ([UserID], [VendorID], [Username], [Role], [IsActive], [FailedLoginAttempts], [Locked], [CreatedOn], [Email], [PasswordHash]) VALUES (3002, 1006, N'DFCU', N'User', 1, 0, 0, CAST(N'2025-07-04T10:13:13.137' AS DateTime), N'dfcu1@gmail.com', 0x593A46A25E11B1DD12EB6D47B6A9E4B70169D896FA89C6C6DEBEF59A53DD8338)
INSERT [dbo].[VendorUser] ([UserID], [VendorID], [Username], [Role], [IsActive], [FailedLoginAttempts], [Locked], [CreatedOn], [Email], [PasswordHash]) VALUES (3003, 1007, N'AMOOTI', N'User', 1, 0, 0, CAST(N'2025-07-04T11:51:30.020' AS DateTime), N'willyamooti80@gmail.com', 0x9787149886BCA1DAC9E5836E5030737EE5B5B9E3E72A5FEF6C282C37B04E1FD6)
INSERT [dbo].[VendorUser] ([UserID], [VendorID], [Username], [Role], [IsActive], [FailedLoginAttempts], [Locked], [CreatedOn], [Email], [PasswordHash]) VALUES (3004, 1007, N'WILLY', N'User', 1, 0, 0, CAST(N'2025-07-04T12:30:38.717' AS DateTime), N'amootiwilly80@gmail.com', 0x9787149886BCA1DAC9E5836E5030737EE5B5B9E3E72A5FEF6C282C37B04E1FD6)
INSERT [dbo].[VendorUser] ([UserID], [VendorID], [Username], [Role], [IsActive], [FailedLoginAttempts], [Locked], [CreatedOn], [Email], [PasswordHash]) VALUES (3005, 1006, N'KATO', N'User', 1, 0, 0, CAST(N'2025-07-04T12:40:13.847' AS DateTime), N'kato@mailinator.com', 0x24118CA739DA593D2BACEFD20B9C133811B5582DB193744CB79DC3B18A77DDB6)
SET IDENTITY_INSERT [dbo].[VendorUser] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__SystemOp__536C85E4FA01BBC2]    Script Date: 07/07/2025 00:24:16 ******/
ALTER TABLE [dbo].[SystemOperator] ADD UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__SystemOp__A9D10534C1327498]    Script Date: 07/07/2025 00:24:16 ******/
ALTER TABLE [dbo].[SystemOperator] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_VendorTable_UserName]    Script Date: 07/07/2025 00:24:16 ******/
ALTER TABLE [dbo].[VendorTable] ADD  CONSTRAINT [UQ_VendorTable_UserName] UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__VendorUs__536C85E481782B90]    Script Date: 07/07/2025 00:24:16 ******/
ALTER TABLE [dbo].[VendorUser] ADD UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_VendorUser_Email]    Script Date: 07/07/2025 00:24:16 ******/
ALTER TABLE [dbo].[VendorUser] ADD  CONSTRAINT [UQ_VendorUser_Email] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuditTrail] ADD  DEFAULT (getdate()) FOR [ActionTime]
GO
ALTER TABLE [dbo].[PortalSMSInbox] ADD  DEFAULT ('PENDING') FOR [Status]
GO
ALTER TABLE [dbo].[PortalSMSInbox] ADD  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[PortalSMSInbox] ADD  DEFAULT ((0)) FOR [Sent]
GO
ALTER TABLE [dbo].[PortalSMSInbox] ADD  DEFAULT (newid()) FOR [VendorTranID]
GO
ALTER TABLE [dbo].[PortalSMSQueue] ADD  DEFAULT (getdate()) FOR [EnqueuedAt]
GO
ALTER TABLE [dbo].[SMSFileUpload] ADD  DEFAULT (getdate()) FOR [UploadedAt]
GO
ALTER TABLE [dbo].[SMSFileUpload] ADD  DEFAULT ('PENDING') FOR [Status]
GO
ALTER TABLE [dbo].[SMSFileUpload] ADD  DEFAULT ((0)) FOR [Processed]
GO
ALTER TABLE [dbo].[SMSFileUploadReport] ADD  DEFAULT (getdate()) FOR [ReportGeneratedOn]
GO
ALTER TABLE [dbo].[SystemOperator] ADD  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[VendorTable] ADD  DEFAULT ((0)) FOR [Credits]
GO
ALTER TABLE [dbo].[VendorTable] ADD  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[VendorUser] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[VendorUser] ADD  DEFAULT ((0)) FOR [FailedLoginAttempts]
GO
ALTER TABLE [dbo].[VendorUser] ADD  DEFAULT ((0)) FOR [Locked]
GO
ALTER TABLE [dbo].[VendorUser] ADD  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[AuditTrail]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[VendorUser] ([UserID])
GO
ALTER TABLE [dbo].[PortalSMSInbox]  WITH CHECK ADD FOREIGN KEY([FileUploadID])
REFERENCES [dbo].[SMSFileUpload] ([FileID])
GO
ALTER TABLE [dbo].[PortalSMSOutboxCompleted]  WITH CHECK ADD FOREIGN KEY([SMSID])
REFERENCES [dbo].[PortalSMSInbox] ([SMSID])
GO
ALTER TABLE [dbo].[PortalSMSQueue]  WITH CHECK ADD FOREIGN KEY([SMSID])
REFERENCES [dbo].[PortalSMSInbox] ([SMSID])
GO
ALTER TABLE [dbo].[SMSFileUpload]  WITH CHECK ADD FOREIGN KEY([UploadedBy])
REFERENCES [dbo].[VendorUser] ([UserID])
GO
ALTER TABLE [dbo].[SMSFileUpload]  WITH CHECK ADD FOREIGN KEY([VendorID])
REFERENCES [dbo].[VendorTable] ([VendorID])
GO
ALTER TABLE [dbo].[SMSFileUploadReport]  WITH CHECK ADD FOREIGN KEY([FileID])
REFERENCES [dbo].[SMSFileUpload] ([FileID])
GO
ALTER TABLE [dbo].[VendorUser]  WITH CHECK ADD FOREIGN KEY([VendorID])
REFERENCES [dbo].[VendorTable] ([VendorID])
GO
