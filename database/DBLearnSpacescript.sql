USE [master]
GO
/****** Object:  Database [kk1]    Script Date: 7/3/2024 6:16:17 PM ******/
CREATE DATABASE [kk1]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'kk1_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\kk1.mdf' , SIZE = 14336KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'kk1_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\kk1.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [kk1] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [kk1].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [kk1] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [kk1] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [kk1] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [kk1] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [kk1] SET ARITHABORT OFF 
GO
ALTER DATABASE [kk1] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [kk1] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [kk1] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [kk1] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [kk1] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [kk1] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [kk1] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [kk1] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [kk1] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [kk1] SET  ENABLE_BROKER 
GO
ALTER DATABASE [kk1] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [kk1] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [kk1] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [kk1] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [kk1] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [kk1] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [kk1] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [kk1] SET RECOVERY FULL 
GO
ALTER DATABASE [kk1] SET  MULTI_USER 
GO
ALTER DATABASE [kk1] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [kk1] SET DB_CHAINING OFF 
GO
ALTER DATABASE [kk1] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [kk1] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [kk1] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [kk1] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'kk1', N'ON'
GO
ALTER DATABASE [kk1] SET QUERY_STORE = ON
GO
ALTER DATABASE [kk1] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [kk1]
GO
/****** Object:  Table [dbo].[Appointment]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Appointment](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NOT NULL,
	[testId] [int] NULL,
	[pracId] [int] NULL,
	[patientId] [int] NOT NULL,
	[appointmentDate] [datetime] NOT NULL,
	[nextAppointDate] [datetime] NOT NULL,
	[feedback] [varchar](40) NOT NULL,
 CONSTRAINT [PK__appointm__6F712F9C110E30A3] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppointmentPersonPractice]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppointmentPersonPractice](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[appointmentId] [int] NULL,
	[personPracticeId] [int] NULL,
 CONSTRAINT [PK_AppointmentPersonPractice] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppointmentPersonTest]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppointmentPersonTest](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[appointmentId] [int] NULL,
	[personTestId] [int] NULL,
 CONSTRAINT [PK_AppointmentPersonTest] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppointmentPractice]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppointmentPractice](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[appointmentId] [int] NULL,
	[practiceId] [int] NULL,
 CONSTRAINT [PK_AppointmentPractice] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppointmentTest]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppointmentTest](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[appointmentId] [int] NULL,
	[testId] [int] NULL,
 CONSTRAINT [PK_AppointmentTest] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CaregiverPurposal]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CaregiverPurposal](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[PatientId] [int] NULL,
	[UserId] [int] NULL,
	[Status] [varchar](20) NULL,
 CONSTRAINT [PK_CaregiverPurposal] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Collection]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Collection](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[uText] [nvarchar](50) NOT NULL,
	[eText] [nvarchar](50) NOT NULL,
	[type] [nvarchar](50) NOT NULL,
	[picPath] [varchar](100) NOT NULL,
	[_group] [varchar](50) NOT NULL,
	[audioPath] [nvarchar](200) NULL,
 CONSTRAINT [PK_collection] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patient]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patient](
	[pid] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](30) NOT NULL,
	[age] [int] NOT NULL,
	[gender] [varchar](6) NOT NULL,
	[stage] [int] NOT NULL,
	[firstTime] [bit] NULL,
	[profPicPath] [nvarchar](100) NULL,
	[userName] [nvarchar](100) NULL,
	[password] [nvarchar](15) NULL,
 CONSTRAINT [PK_patient] PRIMARY KEY CLUSTERED 
(
	[pid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PatientTestCollectionFeedback]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientTestCollectionFeedback](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[patientId] [int] NOT NULL,
	[testCollectionId] [int] NOT NULL,
	[collectionId] [int] NOT NULL,
	[feedback] [bit] NOT NULL,
	[AppointmentId] [int] NULL,
 CONSTRAINT [PK_PatientTestCollectionFeedback] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](30) NOT NULL,
	[gender] [varchar](6) NOT NULL,
	[age] [int] NOT NULL,
	[relation] [varchar](30) NOT NULL,
	[audioPath] [nvarchar](200) NOT NULL,
	[addBy] [int] NULL,
	[picPath] [varchar](100) NULL,
 CONSTRAINT [PK_person] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonIdentification]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonIdentification](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[persontestid] [int] NULL,
	[patientId] [int] NULL,
 CONSTRAINT [PK_PersonIdentification] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonIdentificationFeedback]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonIdentificationFeedback](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[patientId] [int] NOT NULL,
	[personTestCollectionId] [int] NOT NULL,
	[personId] [int] NOT NULL,
	[feedback] [bit] NOT NULL,
	[AppointmentId] [int] NULL,
 CONSTRAINT [PK_PersonIdentificationFeedback] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonPicture]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonPicture](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[imgPath] [nvarchar](50) NULL,
	[personid] [int] NULL,
 CONSTRAINT [PK_PersonPicture] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonPracticCollection]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonPracticCollection](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[personId] [int] NULL,
	[personPractice] [int] NULL,
 CONSTRAINT [PK_PersonPracticCollection] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonPractice]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonPractice](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[patientId] [int] NULL,
	[createdBy] [int] NULL,
	[title] [nvarchar](50) NULL,
 CONSTRAINT [PK_PersonPractice] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonTest]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonTest](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [varchar](50) NULL,
	[createdBy] [int] NULL,
	[patientId] [int] NULL,
 CONSTRAINT [PK_PersonTest] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonTestCollection]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonTestCollection](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[personId] [int] NULL,
	[personTestId] [int] NULL,
	[op1] [int] NULL,
	[op2] [int] NULL,
	[op3] [int] NULL,
	[questionTitle] [varchar](100) NULL,
 CONSTRAINT [PK_PersonTestCollection] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Practice]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Practice](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[stage] [int] NOT NULL,
	[title] [varchar](30) NOT NULL,
	[createBy] [int] NOT NULL,
	[assignedFlag] [int] NULL,
 CONSTRAINT [PK_Practic] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PracticeCollection]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PracticeCollection](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[collectId] [int] NOT NULL,
	[pracId] [int] NOT NULL,
 CONSTRAINT [PK__practicC__879690734D5774D0] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sentence]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sentence](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[sentence1] [varchar](50) NULL,
	[C_group] [varchar](50) NULL,
 CONSTRAINT [PK_Sentence] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Test]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Test](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[stage] [int] NOT NULL,
	[title] [varchar](30) NOT NULL,
	[createBy] [int] NOT NULL,
	[stageIdentfy] [bit] NULL,
 CONSTRAINT [PK_Test] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestCollection]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestCollection](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[collectId] [int] NOT NULL,
	[testId] [int] NOT NULL,
	[op1] [int] NULL,
	[op2] [int] NULL,
	[op3] [int] NULL,
	[question] [varchar](50) NOT NULL,
	[questionAudio] [nvarchar](200) NULL,
 CONSTRAINT [PK__testColl__F43E7193ED89DF09] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TwoPersonTestCollection]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TwoPersonTestCollection](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[personId1] [int] NULL,
	[personId2] [int] NULL,
	[op1] [int] NULL,
	[op2] [int] NULL,
	[op3] [int] NULL,
	[op4] [int] NULL,
	[op5] [int] NULL,
	[op6] [int] NULL,
	[questionTitle] [varchar](100) NULL,
	[personTestId] [int] NULL,
 CONSTRAINT [PK_TwoPersonTestCollection] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[uid] [int] IDENTITY(1,1) NOT NULL,
	[type] [varchar](9) NOT NULL,
	[name] [varchar](30) NOT NULL,
	[username] [varchar](30) NOT NULL,
	[password] [varchar](15) NOT NULL,
	[profPicPath] [varchar](50) NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserPatient]    Script Date: 7/3/2024 6:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPatient](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NOT NULL,
	[patientId] [int] NOT NULL,
 CONSTRAINT [PK_UserPatient] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [fk_Parient] FOREIGN KEY([patientId])
REFERENCES [dbo].[Patient] ([pid])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [fk_Parient]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [fk_pracV] FOREIGN KEY([pracId])
REFERENCES [dbo].[Practice] ([id])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [fk_pracV]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [fk_testV] FOREIGN KEY([testId])
REFERENCES [dbo].[Test] ([id])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [fk_testV]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [fk_user] FOREIGN KEY([userId])
REFERENCES [dbo].[User] ([uid])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [fk_user]
GO
ALTER TABLE [dbo].[AppointmentPersonPractice]  WITH CHECK ADD  CONSTRAINT [FK_AppointmentPersonPractice_Appointment] FOREIGN KEY([appointmentId])
REFERENCES [dbo].[Appointment] ([id])
GO
ALTER TABLE [dbo].[AppointmentPersonPractice] CHECK CONSTRAINT [FK_AppointmentPersonPractice_Appointment]
GO
ALTER TABLE [dbo].[AppointmentPersonPractice]  WITH CHECK ADD  CONSTRAINT [FK_AppointmentPersonPractice_PersonPractice] FOREIGN KEY([personPracticeId])
REFERENCES [dbo].[PersonPractice] ([id])
GO
ALTER TABLE [dbo].[AppointmentPersonPractice] CHECK CONSTRAINT [FK_AppointmentPersonPractice_PersonPractice]
GO
ALTER TABLE [dbo].[AppointmentPersonTest]  WITH CHECK ADD  CONSTRAINT [FK_AppointmentPersonTest_Appointment] FOREIGN KEY([appointmentId])
REFERENCES [dbo].[Appointment] ([id])
GO
ALTER TABLE [dbo].[AppointmentPersonTest] CHECK CONSTRAINT [FK_AppointmentPersonTest_Appointment]
GO
ALTER TABLE [dbo].[AppointmentPersonTest]  WITH CHECK ADD  CONSTRAINT [FK_AppointmentPersonTest_PersonTest] FOREIGN KEY([personTestId])
REFERENCES [dbo].[PersonTest] ([id])
GO
ALTER TABLE [dbo].[AppointmentPersonTest] CHECK CONSTRAINT [FK_AppointmentPersonTest_PersonTest]
GO
ALTER TABLE [dbo].[AppointmentPractice]  WITH CHECK ADD  CONSTRAINT [FK_AppointmentPractice_Appointment] FOREIGN KEY([appointmentId])
REFERENCES [dbo].[Appointment] ([id])
GO
ALTER TABLE [dbo].[AppointmentPractice] CHECK CONSTRAINT [FK_AppointmentPractice_Appointment]
GO
ALTER TABLE [dbo].[AppointmentPractice]  WITH CHECK ADD  CONSTRAINT [FK_AppointmentPractice_Practice] FOREIGN KEY([practiceId])
REFERENCES [dbo].[Practice] ([id])
GO
ALTER TABLE [dbo].[AppointmentPractice] CHECK CONSTRAINT [FK_AppointmentPractice_Practice]
GO
ALTER TABLE [dbo].[AppointmentTest]  WITH CHECK ADD  CONSTRAINT [FK_AppointmentTest_Appointment] FOREIGN KEY([appointmentId])
REFERENCES [dbo].[Appointment] ([id])
GO
ALTER TABLE [dbo].[AppointmentTest] CHECK CONSTRAINT [FK_AppointmentTest_Appointment]
GO
ALTER TABLE [dbo].[AppointmentTest]  WITH CHECK ADD  CONSTRAINT [FK_AppointmentTest_Test] FOREIGN KEY([testId])
REFERENCES [dbo].[Test] ([id])
GO
ALTER TABLE [dbo].[AppointmentTest] CHECK CONSTRAINT [FK_AppointmentTest_Test]
GO
ALTER TABLE [dbo].[CaregiverPurposal]  WITH CHECK ADD  CONSTRAINT [FK_CaregiverPurposal_Patient] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Patient] ([pid])
GO
ALTER TABLE [dbo].[CaregiverPurposal] CHECK CONSTRAINT [FK_CaregiverPurposal_Patient]
GO
ALTER TABLE [dbo].[CaregiverPurposal]  WITH CHECK ADD  CONSTRAINT [FK_CaregiverPurposal_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([uid])
GO
ALTER TABLE [dbo].[CaregiverPurposal] CHECK CONSTRAINT [FK_CaregiverPurposal_User]
GO
ALTER TABLE [dbo].[PatientTestCollectionFeedback]  WITH CHECK ADD  CONSTRAINT [fk_collectionPtc] FOREIGN KEY([collectionId])
REFERENCES [dbo].[Collection] ([id])
GO
ALTER TABLE [dbo].[PatientTestCollectionFeedback] CHECK CONSTRAINT [fk_collectionPtc]
GO
ALTER TABLE [dbo].[PatientTestCollectionFeedback]  WITH CHECK ADD  CONSTRAINT [fk_patientPtc] FOREIGN KEY([patientId])
REFERENCES [dbo].[Patient] ([pid])
GO
ALTER TABLE [dbo].[PatientTestCollectionFeedback] CHECK CONSTRAINT [fk_patientPtc]
GO
ALTER TABLE [dbo].[PatientTestCollectionFeedback]  WITH CHECK ADD  CONSTRAINT [FK_PatientTestCollectionFeedback_Appointment] FOREIGN KEY([AppointmentId])
REFERENCES [dbo].[Appointment] ([id])
GO
ALTER TABLE [dbo].[PatientTestCollectionFeedback] CHECK CONSTRAINT [FK_PatientTestCollectionFeedback_Appointment]
GO
ALTER TABLE [dbo].[PatientTestCollectionFeedback]  WITH CHECK ADD  CONSTRAINT [FK_TestCollection] FOREIGN KEY([testCollectionId])
REFERENCES [dbo].[TestCollection] ([id])
GO
ALTER TABLE [dbo].[PatientTestCollectionFeedback] CHECK CONSTRAINT [FK_TestCollection]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_User] FOREIGN KEY([addBy])
REFERENCES [dbo].[User] ([uid])
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_User]
GO
ALTER TABLE [dbo].[PersonIdentification]  WITH CHECK ADD  CONSTRAINT [FK_PersonIdentification_patient] FOREIGN KEY([patientId])
REFERENCES [dbo].[Patient] ([pid])
GO
ALTER TABLE [dbo].[PersonIdentification] CHECK CONSTRAINT [FK_PersonIdentification_patient]
GO
ALTER TABLE [dbo].[PersonIdentification]  WITH CHECK ADD  CONSTRAINT [FK_PersonIdentification_PersonTest] FOREIGN KEY([persontestid])
REFERENCES [dbo].[PersonTest] ([id])
GO
ALTER TABLE [dbo].[PersonIdentification] CHECK CONSTRAINT [FK_PersonIdentification_PersonTest]
GO
ALTER TABLE [dbo].[PersonIdentificationFeedback]  WITH CHECK ADD  CONSTRAINT [FK_PersonIdentificationFeedback_Appointment] FOREIGN KEY([AppointmentId])
REFERENCES [dbo].[Appointment] ([id])
GO
ALTER TABLE [dbo].[PersonIdentificationFeedback] CHECK CONSTRAINT [FK_PersonIdentificationFeedback_Appointment]
GO
ALTER TABLE [dbo].[PersonIdentificationFeedback]  WITH CHECK ADD  CONSTRAINT [FK_PersonIdentificationFeedback_patient] FOREIGN KEY([patientId])
REFERENCES [dbo].[Patient] ([pid])
GO
ALTER TABLE [dbo].[PersonIdentificationFeedback] CHECK CONSTRAINT [FK_PersonIdentificationFeedback_patient]
GO
ALTER TABLE [dbo].[PersonIdentificationFeedback]  WITH CHECK ADD  CONSTRAINT [FK_PersonIdentificationFeedback_person] FOREIGN KEY([personId])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[PersonIdentificationFeedback] CHECK CONSTRAINT [FK_PersonIdentificationFeedback_person]
GO
ALTER TABLE [dbo].[PersonIdentificationFeedback]  WITH CHECK ADD  CONSTRAINT [FK_PersonIdentificationFeedback_PersonTest] FOREIGN KEY([personTestCollectionId])
REFERENCES [dbo].[PersonTestCollection] ([id])
GO
ALTER TABLE [dbo].[PersonIdentificationFeedback] CHECK CONSTRAINT [FK_PersonIdentificationFeedback_PersonTest]
GO
ALTER TABLE [dbo].[PersonPicture]  WITH CHECK ADD  CONSTRAINT [FK_PersonPicture_person] FOREIGN KEY([personid])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[PersonPicture] CHECK CONSTRAINT [FK_PersonPicture_person]
GO
ALTER TABLE [dbo].[PersonPracticCollection]  WITH CHECK ADD  CONSTRAINT [FK_PersonPracticCollection_Person] FOREIGN KEY([personId])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[PersonPracticCollection] CHECK CONSTRAINT [FK_PersonPracticCollection_Person]
GO
ALTER TABLE [dbo].[PersonPracticCollection]  WITH CHECK ADD  CONSTRAINT [FK_PersonPracticCollection_PersonPractice] FOREIGN KEY([personPractice])
REFERENCES [dbo].[PersonPractice] ([id])
GO
ALTER TABLE [dbo].[PersonPracticCollection] CHECK CONSTRAINT [FK_PersonPracticCollection_PersonPractice]
GO
ALTER TABLE [dbo].[PersonPractice]  WITH CHECK ADD  CONSTRAINT [FK_PersonPractice_patient] FOREIGN KEY([patientId])
REFERENCES [dbo].[Patient] ([pid])
GO
ALTER TABLE [dbo].[PersonPractice] CHECK CONSTRAINT [FK_PersonPractice_patient]
GO
ALTER TABLE [dbo].[PersonPractice]  WITH CHECK ADD  CONSTRAINT [FK_PersonPractice_User] FOREIGN KEY([createdBy])
REFERENCES [dbo].[User] ([uid])
GO
ALTER TABLE [dbo].[PersonPractice] CHECK CONSTRAINT [FK_PersonPractice_User]
GO
ALTER TABLE [dbo].[PersonTest]  WITH CHECK ADD  CONSTRAINT [FK_PersonTest_Patient] FOREIGN KEY([patientId])
REFERENCES [dbo].[Patient] ([pid])
GO
ALTER TABLE [dbo].[PersonTest] CHECK CONSTRAINT [FK_PersonTest_Patient]
GO
ALTER TABLE [dbo].[PersonTest]  WITH CHECK ADD  CONSTRAINT [FK_PersonTest_PersonTest] FOREIGN KEY([id])
REFERENCES [dbo].[PersonTest] ([id])
GO
ALTER TABLE [dbo].[PersonTest] CHECK CONSTRAINT [FK_PersonTest_PersonTest]
GO
ALTER TABLE [dbo].[PersonTest]  WITH CHECK ADD  CONSTRAINT [FK_PersonTest_User] FOREIGN KEY([createdBy])
REFERENCES [dbo].[User] ([uid])
GO
ALTER TABLE [dbo].[PersonTest] CHECK CONSTRAINT [FK_PersonTest_User]
GO
ALTER TABLE [dbo].[PersonTestCollection]  WITH CHECK ADD  CONSTRAINT [FK_personOp1] FOREIGN KEY([op1])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[PersonTestCollection] CHECK CONSTRAINT [FK_personOp1]
GO
ALTER TABLE [dbo].[PersonTestCollection]  WITH CHECK ADD  CONSTRAINT [FK_personOp2] FOREIGN KEY([op2])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[PersonTestCollection] CHECK CONSTRAINT [FK_personOp2]
GO
ALTER TABLE [dbo].[PersonTestCollection]  WITH CHECK ADD  CONSTRAINT [FK_personOp3] FOREIGN KEY([op3])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[PersonTestCollection] CHECK CONSTRAINT [FK_personOp3]
GO
ALTER TABLE [dbo].[PersonTestCollection]  WITH CHECK ADD  CONSTRAINT [FK_PersonTestCollection_person] FOREIGN KEY([personId])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[PersonTestCollection] CHECK CONSTRAINT [FK_PersonTestCollection_person]
GO
ALTER TABLE [dbo].[PersonTestCollection]  WITH CHECK ADD  CONSTRAINT [FK_PersonTestCollection_PersonTest] FOREIGN KEY([personTestId])
REFERENCES [dbo].[PersonTest] ([id])
GO
ALTER TABLE [dbo].[PersonTestCollection] CHECK CONSTRAINT [FK_PersonTestCollection_PersonTest]
GO
ALTER TABLE [dbo].[Practice]  WITH CHECK ADD  CONSTRAINT [FK_pracCreateBy] FOREIGN KEY([createBy])
REFERENCES [dbo].[User] ([uid])
GO
ALTER TABLE [dbo].[Practice] CHECK CONSTRAINT [FK_pracCreateBy]
GO
ALTER TABLE [dbo].[PracticeCollection]  WITH CHECK ADD  CONSTRAINT [fk_practice] FOREIGN KEY([pracId])
REFERENCES [dbo].[Practice] ([id])
GO
ALTER TABLE [dbo].[PracticeCollection] CHECK CONSTRAINT [fk_practice]
GO
ALTER TABLE [dbo].[Test]  WITH CHECK ADD  CONSTRAINT [FK_TestCreateBy] FOREIGN KEY([createBy])
REFERENCES [dbo].[User] ([uid])
GO
ALTER TABLE [dbo].[Test] CHECK CONSTRAINT [FK_TestCreateBy]
GO
ALTER TABLE [dbo].[TestCollection]  WITH CHECK ADD  CONSTRAINT [fk_collectionT] FOREIGN KEY([collectId])
REFERENCES [dbo].[Collection] ([id])
GO
ALTER TABLE [dbo].[TestCollection] CHECK CONSTRAINT [fk_collectionT]
GO
ALTER TABLE [dbo].[TestCollection]  WITH CHECK ADD  CONSTRAINT [FK_op1] FOREIGN KEY([op1])
REFERENCES [dbo].[Collection] ([id])
GO
ALTER TABLE [dbo].[TestCollection] CHECK CONSTRAINT [FK_op1]
GO
ALTER TABLE [dbo].[TestCollection]  WITH CHECK ADD  CONSTRAINT [FK_op2] FOREIGN KEY([op2])
REFERENCES [dbo].[Collection] ([id])
GO
ALTER TABLE [dbo].[TestCollection] CHECK CONSTRAINT [FK_op2]
GO
ALTER TABLE [dbo].[TestCollection]  WITH CHECK ADD  CONSTRAINT [FK_op3] FOREIGN KEY([op3])
REFERENCES [dbo].[Collection] ([id])
GO
ALTER TABLE [dbo].[TestCollection] CHECK CONSTRAINT [FK_op3]
GO
ALTER TABLE [dbo].[TestCollection]  WITH CHECK ADD  CONSTRAINT [fk_test] FOREIGN KEY([testId])
REFERENCES [dbo].[Test] ([id])
GO
ALTER TABLE [dbo].[TestCollection] CHECK CONSTRAINT [fk_test]
GO
ALTER TABLE [dbo].[TwoPersonTestCollection]  WITH CHECK ADD  CONSTRAINT [FK_TwoPersonTestCollection_Person] FOREIGN KEY([personId1])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[TwoPersonTestCollection] CHECK CONSTRAINT [FK_TwoPersonTestCollection_Person]
GO
ALTER TABLE [dbo].[TwoPersonTestCollection]  WITH CHECK ADD  CONSTRAINT [FK_TwoPersonTestCollection_Person1] FOREIGN KEY([personId2])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[TwoPersonTestCollection] CHECK CONSTRAINT [FK_TwoPersonTestCollection_Person1]
GO
ALTER TABLE [dbo].[TwoPersonTestCollection]  WITH CHECK ADD  CONSTRAINT [FK_TwoPersonTestCollection_Person2] FOREIGN KEY([op1])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[TwoPersonTestCollection] CHECK CONSTRAINT [FK_TwoPersonTestCollection_Person2]
GO
ALTER TABLE [dbo].[TwoPersonTestCollection]  WITH CHECK ADD  CONSTRAINT [FK_TwoPersonTestCollection_Person3] FOREIGN KEY([op2])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[TwoPersonTestCollection] CHECK CONSTRAINT [FK_TwoPersonTestCollection_Person3]
GO
ALTER TABLE [dbo].[TwoPersonTestCollection]  WITH CHECK ADD  CONSTRAINT [FK_TwoPersonTestCollection_Person4] FOREIGN KEY([op3])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[TwoPersonTestCollection] CHECK CONSTRAINT [FK_TwoPersonTestCollection_Person4]
GO
ALTER TABLE [dbo].[TwoPersonTestCollection]  WITH CHECK ADD  CONSTRAINT [FK_TwoPersonTestCollection_Person5] FOREIGN KEY([op4])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[TwoPersonTestCollection] CHECK CONSTRAINT [FK_TwoPersonTestCollection_Person5]
GO
ALTER TABLE [dbo].[TwoPersonTestCollection]  WITH CHECK ADD  CONSTRAINT [FK_TwoPersonTestCollection_Person6] FOREIGN KEY([op6])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[TwoPersonTestCollection] CHECK CONSTRAINT [FK_TwoPersonTestCollection_Person6]
GO
ALTER TABLE [dbo].[TwoPersonTestCollection]  WITH CHECK ADD  CONSTRAINT [FK_TwoPersonTestCollection_Person7] FOREIGN KEY([op5])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[TwoPersonTestCollection] CHECK CONSTRAINT [FK_TwoPersonTestCollection_Person7]
GO
ALTER TABLE [dbo].[TwoPersonTestCollection]  WITH CHECK ADD  CONSTRAINT [FK_TwoPersonTestCollection_PersonTest] FOREIGN KEY([personTestId])
REFERENCES [dbo].[PersonTest] ([id])
GO
ALTER TABLE [dbo].[TwoPersonTestCollection] CHECK CONSTRAINT [FK_TwoPersonTestCollection_PersonTest]
GO
ALTER TABLE [dbo].[UserPatient]  WITH CHECK ADD  CONSTRAINT [FK_patientId] FOREIGN KEY([patientId])
REFERENCES [dbo].[Patient] ([pid])
GO
ALTER TABLE [dbo].[UserPatient] CHECK CONSTRAINT [FK_patientId]
GO
ALTER TABLE [dbo].[UserPatient]  WITH CHECK ADD  CONSTRAINT [FK_userId] FOREIGN KEY([userId])
REFERENCES [dbo].[User] ([uid])
GO
ALTER TABLE [dbo].[UserPatient] CHECK CONSTRAINT [FK_userId]
GO
USE [master]
GO
ALTER DATABASE [kk1] SET  READ_WRITE 
GO
