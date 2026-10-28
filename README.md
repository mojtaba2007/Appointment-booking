# Appointment Booking

A Persian-language appointment booking web application built with ASP.NET Web Forms and SQL Server.

## Features

- Customer registration, sign-in, and profile pages
- Service browsing and appointment booking
- Appointment management for customers and administrators
- Persian-language interface and date handling
- Bootstrap-based responsive layouts

## Requirements

- Windows
- Visual Studio with the **ASP.NET and web development** workload
- .NET Framework 4.7.2 Developer Pack
- SQL Server and a database configured for this application

## Getting started

1. Clone the repository and open `Appointment booking.slnx` in Visual Studio.
2. Restore the NuGet packages when prompted, or use **Build > Restore NuGet Packages**.
3. Configure the `Appointment` connection string in `Web.config` for your SQL Server instance. The checked-in value uses Windows authentication and a local database named `AppointmentDB`.
4. Create and populate the database using a schema compatible with the application. **This repository does not currently include a database schema or seed data.**
5. Build and run the project with IIS Express. The user-facing start page is `Pages/User/Default.aspx`.

Do not commit credentials, production connection strings, database backups, or publish profiles. Keep machine-specific Visual Studio settings and build output out of commits; the repository's `.gitignore` already excludes these files.

## Project layout

| Path | Description |
| --- | --- |
| `Pages/User/` | Customer-facing pages |
| `Pages/Admin/` | Administration pages |
| `App_Code/` | Shared application code |
| `App_Start/` | URL routing and asset bundles |
| `Content/Assets/` | Application styles, scripts, and images |
| `Content/`, `Scripts/` | Bootstrap, jQuery, and application assets |

## Notes

- The project targets **.NET Framework 4.7.2** and uses `packages.config` for NuGet dependencies.
- SQL Server tables and data are managed separately; connection settings alone do not initialize the database.
- No license has been specified for this project.

---

# سامانهٔ نوبت‌دهی

یک برنامهٔ وب فارسی برای رزرو و مدیریت نوبت، ساخته‌شده با ASP.NET Web Forms و SQL Server.

## امکانات

- ثبت‌نام، ورود و مدیریت نمایهٔ کاربران
- مشاهدهٔ خدمات و رزرو نوبت
- مدیریت نوبت‌ها برای کاربران و مدیران
- رابط فارسی و پشتیبانی از تاریخ شمسی
- صفحات واکنش‌گرا بر پایهٔ Bootstrap

## پیش‌نیازها

- ویندوز
- Visual Studio با workload **ASP.NET and web development**
- Developer Pack مربوط به **.NET Framework 4.7.2**
- SQL Server و پایگاه دادهٔ سازگار با برنامه

## راه‌اندازی

1. مخزن را clone و فایل `Appointment booking.slnx` را در Visual Studio باز کنید.
2. بسته‌های NuGet را در صورت درخواست Visual Studio بازیابی کنید.
3. رشتهٔ اتصال `Appointment` را در `Web.config` متناسب با SQL Server خود تنظیم کنید. مقدار پیش‌فرض از Windows Authentication و پایگاه دادهٔ محلی `AppointmentDB` استفاده می‌کند.
4. پایگاه داده را با ساختاری سازگار با برنامه ایجاد و مقداردهی کنید. **در حال حاضر اسکریپت ساختار پایگاه داده و دادهٔ اولیه در این مخزن وجود ندارد.**
5. پروژه را با IIS Express بسازید و اجرا کنید. صفحهٔ شروع کاربر `Pages/User/Default.aspx` است.

اطلاعات ورود، رشتهٔ اتصال محیط عملیاتی، نسخهٔ پشتیبان پایگاه داده و تنظیمات انتشار را commit نکنید. فایل‌های محلی Visual Studio و خروجی ساخت نیز در `.gitignore` نادیده گرفته می‌شوند.

## مجوز

هنوز مجوزی برای این پروژه تعیین نشده است.
