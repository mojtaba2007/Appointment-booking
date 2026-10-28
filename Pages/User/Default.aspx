<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/User/Site1.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Appointment_booking.Pages.User.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../../Content/Assets/User/CSS/default.css" rel="stylesheet" />
    <style>
        p {
            color: #9ca3af;
        }

        .hero-section {
            position: relative;
            padding: 120px 30px;
            border-radius: 20px;
            background: linear-gradient(to left, #111827, #0B0F14);
            overflow: hidden;
        }

        .hero-overlay {
            position: absolute;
            inset: 0;
            background-image: url("../../Content/Assets/n.jpeg");
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

            .hero-overlay::before {
                content: "";
                position: absolute;
                inset: 0;
                background: rgba(0, 0, 0, 0.4);
            }

        .hero-content {
            position: relative;
            z-index: 1;
            color: aliceblue;
        }

        .hero-badge {
            color: #D4AF37;
            font-weight: 700;
        }

        .hero-title {
            font-size: 52px;
            font-weight: 800;
            margin: 20px 0;
        }

        .hero-subtitle {
            color: #9ca3af;
            font-size: 18px;
        }

        .hero-btn {
            margin-top: 20px;
        }

        .section-title h2 {
            color: #D4AF37;
            font-weight: 800;
        }

        .section-title p {
            color: #9ca3af;
        }

        .service-card,
        .why-card {
            background: #111827;
            border: 2px solid rgba(212,175,55,.12);
            border-radius: 14px;
            padding: 30px;
            transition: .3s;
            height: 162.8px;
            animation: pulse 2s ease-in-out infinite;
        }


        @keyframes pulse {
            50% {
                box-shadow: 0 0 #ff7e00, 0 0 36px #6d3c0c;
            }
        }

        .why-card {
            height: 90px !important;
        }

            .service-card:hover,
            .why-card:hover {
                transform: translateY(-5px);
                border-color: #D4AF37;
            }

            .service-card h4,
            .why-card h5 {
                color: #fff;
            }

        .service-card p {
            color: #9ca3af;
        }

        .cta-section {
            background: #111827;
            padding: 60px;
            border-radius: 20px;
            border: 1px solid rgba(212,175,55,.15);
        }

            .cta-section h2 {
                color: #D4AF37;
            }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <br />
    <br />
    <br />
    <!-- Hero Section -->
    <section class="hero-section text-center">

        <div class="hero-overlay"></div>

        <div class="hero-content">
            <span class="hero-badge">آرایشگاه مردانه ریش و قیچی</span>

            <h1 class="hero-title">جایی که استایل مردانه معنا پیدا می‌کند
            </h1>

            <p class="hero-subtitle">
                تجربه‌ای متفاوت از اصلاح، فید تخصصی، فرم‌دهی ریش و خدمات VIP
            </p>

            <a href="BookAppointment.aspx" class="btn btn-gold hero-btn">رزرو نوبت
            </a>
        </div>

    </section>

    <!-- Services -->
    <section class="services-section mt-5">

        <div class="section-title text-center mb-5">
            <h2>خدمات ما</h2>
            <p>آنچه برای استایل کامل نیاز داری</p>
        </div>

        <div class="row g-4">

            <div class="col-md-4">
                <div class="service-card">
                    <h4>اصلاح مو</h4>
                    <p>اصلاح کلاسیک و مدرن مطابق استایل شما</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="service-card">
                    <h4>فید تخصصی</h4>
                    <p>فید حرفه‌ای با دقت بالا و جزئیات کامل</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="service-card">
                    <h4>اصلاح ریش</h4>
                    <p>فرم‌دهی و طراحی ریش متناسب با فرم صورت</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="service-card">
                    <h4>پاکسازی پوست</h4>
                    <p>پاکسازی حرفه‌ای برای طراوت و شادابی پوست</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="service-card">
                    <h4>گریم داماد</h4>
                    <p>آماده‌سازی کامل برای مراسم‌های خاص</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="service-card">
                    <h4>VIP Service</h4>
                    <p>خدمات اختصاصی با کیفیت بالا و زمان ویژه</p>
                </div>
            </div>

        </div>

    </section>

    <!-- Why Us -->
    <section class="why-us mt-5">

        <div class="section-title text-center mb-5">
            <h2>چرا ریش و قیچی؟</h2>
        </div>

        <div class="row text-center">

            <div class="col-md-3">
                <div class="why-card">
                    <h5>آرایشگران حرفه‌ای</h5>
                </div>
            </div>

            <div class="col-md-3">
                <div class="why-card">
                    <h5>رزرو سریع آنلاین</h5>
                </div>
            </div>

            <div class="col-md-3">
                <div class="why-card">
                    <h5>محیط لوکس و حرفه‌ای</h5>
                </div>
            </div>

            <div class="col-md-3">
                <div class="why-card">
                    <h5>استفاده از بهترین متریال</h5>
                </div>
            </div>

        </div>

    </section>

    <!-- CTA -->
    <section class="cta-section text-center mt-5">

        <h2>وقتشه استایلتو ارتقا بدی</h2>
        <p>همین حالا نوبت خودت رو رزرو کن</p>

        <a href="BookAppointment.aspx" class="btn btn-gold">رزرو آنلاین
        </a>

    </section>

</asp:Content>
