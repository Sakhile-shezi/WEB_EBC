<%@ Page Title="About Us - East Boom CHC" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="WebApplication1.About" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<style>
/* EastBoom About page - scoped styling */
.eb-about {
    --dark:#103d31;
    --green:#1a7954;
    --lime:#c9f28b;
    --ink:#173e30;
    --muted:#698074;
    --line:#dcebe0;
    width:100%;
    margin:4px auto 34px;
    color:var(--ink);
    font-family:'Segoe UI',Arial,sans-serif;
}

.eb-about, .eb-about *,
.eb-about *::before, .eb-about *::after {
    box-sizing:border-box;
}

.eb-about h1, .eb-about h2,
.eb-about h3, .eb-about p {
    margin-top:0;
}

.eb-about a {
    text-decoration:none;
}

.eb-about .ab-btn {
    display:inline-flex;
    align-items:center;
    justify-content:center;
    gap:10px;
    min-height:47px;
    padding:12px 21px;
    border-radius:12px;
    font-size:12px;
    font-weight:800;
    transition:transform .25s,background .25s;
}

.eb-about .ab-btn:hover {
    transform:translateY(-3px);
}

.eb-about .ab-btn-lime {
    background:var(--lime);
    color:#153f2c;
}

.eb-about .ab-btn-lime:hover {
    background:#dcffad;
    color:#153f2c;
}

.eb-about .ab-btn-outline {
    border:1px solid #badac5;
    color:#1b6549;
    background:#fff;
}

.eb-about .ab-kicker {
    display:inline-flex;
    align-items:center;
    gap:8px;
    font-size:10px;
    font-weight:900;
    letter-spacing:1.6px;
    text-transform:uppercase;
    color:#23825c;
}

.eb-about .ab-kicker::before {
    content:"";
    width:23px;
    height:2px;
    background:#77bb89;
}

.eb-about .ab-title {
    font-size:clamp(28px,3.2vw,41px);
    line-height:1.18;
    letter-spacing:-1.3px;
    font-weight:800;
    margin:13px 0 14px;
    color:#173e30;
}

.eb-about .ab-title em {
    font-style:normal;
    color:#208258;
}

.eb-about .ab-description {
    color:var(--muted);
    font-size:13px;
    line-height:1.85;
    max-width:650px;
}

/* HERO SECTION */
.eb-about .ab-hero {
    position:relative;
    display:grid;
    grid-template-columns:1.02fr .98fr;
    min-height:455px;
    overflow:hidden;
    border-radius:25px;
    background:linear-gradient(126deg,#0e3a2e,#15543e);
    box-shadow:0 25px 47px rgba(13,59,36,.13);
}

.eb-about .ab-hero-content {
    position:relative;
    z-index:2;
    padding:66px 25px 66px 59px;
    display:flex;
    flex-direction:column;
    align-items:flex-start;
    justify-content:center;
}

.eb-about .ab-hero-tag {
    display:inline-flex;
    align-items:center;
    gap:9px;
    border:1px solid rgba(211,245,192,.35);
    background:rgba(255,255,255,.075);
    color:#e9f8e6;
    border-radius:60px;
    padding:8px 12px;
    font-size:10px;
    font-weight:800;
    letter-spacing:1px;
    text-transform:uppercase;
}

.eb-about .ab-spark {
    height:8px;
    width:8px;
    background:#c9f28b;
    border-radius:50%;
    box-shadow:0 0 0 5px rgba(201,242,139,.1);
}

.eb-about .ab-hero h1 {
    color:#fff;
    font-weight:800;
    letter-spacing:-1.9px;
    line-height:1.09;
    font-size:clamp(35px,3.7vw,54px);
    margin:22px 0 18px;
}

.eb-about .ab-hero h1 em {
    font-style:normal;
    color:var(--lime);
}

.eb-about .ab-hero p {
    color:#d9ebdf;
    font-size:13.5px;
    line-height:1.86;
    max-width:470px;
    margin:0 0 26px;
}

.eb-about .ab-hero-actions {
    display:flex;
    flex-wrap:wrap;
    gap:11px;
}

.eb-about .ab-hero-photo {
    position:relative;
    min-height:455px;
    overflow:hidden;
    border-radius:135px 0 0 135px;
    background:#387d5d;
}

.eb-about .ab-hero-photo img {
    width:100%;
    height:100%;
    object-fit:cover;
    object-position:64% center;
    animation:ab-zoom 9s ease-in-out alternate infinite;
}

.eb-about .ab-photo-note {
    position:absolute;
    z-index:2;
    left:26px;
    bottom:30px;
    background:rgba(255,255,255,.94);
    padding:12px 15px;
    border-radius:13px;
    color:#184631;
    box-shadow:0 12px 27px rgba(15,45,26,.12);
    animation:ab-float 5s ease-in-out infinite;
}

.eb-about .ab-photo-note strong {
    display:block;
    font-size:12px;
}

.eb-about .ab-photo-note small {
    display:block;
    font-size:10px;
    color:#62796c;
    margin-top:3px;
}

/* PAGE CONTENT */
.eb-about .ab-content {
    background:linear-gradient(
        180deg,#f3faf5,#fff 34%,#f6faf7
    );
    border:1px solid #e2ece5;
    border-radius:0 0 25px 25px;
    padding:42px 41px 34px;
}

/* WHO WE ARE */
.eb-about .ab-intro {
    display:grid;
    grid-template-columns:.9fr 1.1fr;
    gap:56px;
    align-items:center;
    padding:28px 5px 65px;
}

.eb-about .ab-facility-photo {
    position:relative;
    overflow:hidden;
    border-radius:22px;
    background:#dcebe1;
    box-shadow:0 18px 39px rgba(15,75,41,.11);
}

.eb-about .ab-facility-photo img {
    width:100%;
    height:317px;
    object-fit:cover;
    transition:transform .6s ease;
}

.eb-about .ab-facility-photo:hover img {
    transform:scale(1.05);
}

.eb-about .ab-facility-label {
    position:absolute;
    left:16px;
    bottom:16px;
    background:rgba(255,255,255,.94);
    padding:11px 14px;
    border-radius:11px;
    color:#1a5338;
    font-size:11px;
    font-weight:800;
}

.eb-about .ab-intro-copy p {
    font-size:13px;
    line-height:1.87;
    color:#667f6f;
    margin-bottom:13px;
}

.eb-about .ab-location {
    display:inline-flex;
    padding:11px 14px;
    border-radius:11px;
    background:#e8f5ec;
    color:#24694b;
    font-size:11.5px;
    font-weight:750;
}

/* VISION AND MISSION */
.eb-about .ab-identity {
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:16px;
    margin:0 4px 62px;
}

.eb-about .ab-philosophy-card {
    padding:29px;
    background:#fff;
    border:1px solid var(--line);
    border-radius:19px;
    box-shadow:0 12px 31px rgba(37,81,49,.045);
    transition:transform .25s,box-shadow .25s;
}

.eb-about .ab-philosophy-card:hover {
    transform:translateY(-4px);
    box-shadow:0 17px 28px rgba(37,81,49,.085);
}

.eb-about .ab-philosophy-icon {
    width:46px;
    height:46px;
    display:grid;
    place-items:center;
    background:#e2f4e8;
    color:#197953;
    border-radius:14px;
    margin-bottom:18px;
    font-size:23px;
}

.eb-about .ab-philosophy-card h3 {
    font-size:20px;
    font-weight:800;
    margin:0 0 11px;
}

.eb-about .ab-philosophy-card p {
    font-size:12.5px;
    line-height:1.82;
    color:#728578;
    margin:0;
}

/* CORE VALUES */
.eb-about .ab-section-heading {
    margin:0 4px 25px;
}

.eb-about .ab-values {
    padding-bottom:70px;
}

.eb-about .ab-value-grid {
    display:grid;
    grid-template-columns:repeat(4,minmax(0,1fr));
    gap:13px;
}

.eb-about .ab-value-card {
    padding:23px 18px;
    background:#fff;
    border:1px solid #dfeae2;
    border-radius:17px;
    transition:transform .25s,box-shadow .25s;
}

.eb-about .ab-value-card:hover {
    transform:translateY(-6px);
    box-shadow:0 16px 26px rgba(32,82,49,.09);
}

.eb-about .ab-value-mark {
    font-size:17px;
    font-weight:900;
    color:#269563;
    background:#e7f6e9;
    width:39px;
    height:39px;
    border-radius:12px;
    display:grid;
    place-items:center;
    margin-bottom:18px;
}

.eb-about .ab-value-card h3 {
    font-size:14px;
    font-weight:820;
    margin:0 0 8px;
}

.eb-about .ab-value-card p {
    font-size:11.3px;
    line-height:1.67;
    color:#768a7d;
    margin:0;
}

/* SYSTEM FEATURES */
.eb-about .ab-portal {
    background:#ebf7ef;
    border:1px solid #dbebe0;
    padding:36px 32px;
    border-radius:22px;
    margin-bottom:62px;
}

.eb-about .ab-feature-grid {
    display:grid;
    grid-template-columns:repeat(3,minmax(0,1fr));
    gap:14px;
}

.eb-about .ab-feature {
    padding:21px 20px;
    background:#fff;
    border:1px solid #dbeadf;
    border-radius:17px;
    transition:transform .25s,box-shadow .25s;
}

.eb-about .ab-feature:hover {
    transform:translateY(-5px);
    box-shadow:0 16px 29px rgba(32,82,49,.08);
}

.eb-about .ab-feature-no {
    display:inline-block;
    font-size:11px;
    letter-spacing:1px;
    color:#26835a;
    font-weight:900;
    margin-bottom:18px;
}

.eb-about .ab-feature h3 {
    font-size:15px;
    font-weight:830;
    margin:0 0 9px;
}

.eb-about .ab-feature p {
    font-size:11.6px;
    line-height:1.78;
    color:#6c8474;
    margin:0 0 14px;
}

.eb-about .ab-feature a {
    font-size:11px;
    color:#187650;
    font-weight:830;
}

/* FINAL ACTION */
.eb-about .ab-closing {
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:22px;
    padding:34px 38px;
    border-radius:22px;
    background:linear-gradient(116deg,#104333,#18684b);
    color:#fff;
}

.eb-about .ab-closing h2 {
    font-size:29px;
    font-weight:800;
    color:#fff;
    margin:0 0 8px;
}

.eb-about .ab-closing p {
    font-size:12px;
    color:#d8eadd;
    margin:0;
}

.eb-about .ab-source-note {
    font-size:10.5px;
    line-height:1.7;
    text-align:center;
    color:#8b9b90;
    padding:20px 8px 2px;
}

.eb-about .ab-source-note a {
    color:#397b56;
    text-decoration:underline;
}

/* SCROLL ANIMATIONS */
.eb-about.ab-motion .ab-reveal {
    opacity:0;
    transform:translateY(20px);
    transition:opacity .7s ease,transform .7s ease;
}

.eb-about.ab-motion .ab-reveal.ab-in {
    opacity:1;
    transform:none;
}

@keyframes ab-float {
    0%,100% {transform:translateY(0)}
    50% {transform:translateY(-8px)}
}

@keyframes ab-zoom {
    from {transform:scale(1)}
    to {transform:scale(1.065)}
}

/* RESPONSIVE */
@media(max-width:900px) {
    .eb-about .ab-intro {
        gap:30px;
    }
    .eb-about .ab-value-grid {
        grid-template-columns:repeat(2,1fr);
    }
}

@media(max-width:760px) {
    .eb-about .ab-hero,
    .eb-about .ab-intro,
    .eb-about .ab-identity,
    .eb-about .ab-feature-grid {
        grid-template-columns:1fr;
    }

    .eb-about .ab-hero-content {
        padding:45px 27px 35px;
    }

    .eb-about .ab-hero-photo {
        min-height:320px;
        height:320px;
        border-radius:100px 100px 0 0;
    }

    .eb-about .ab-content {
        padding:30px 20px;
    }

    .eb-about .ab-closing {
        flex-direction:column;
        align-items:flex-start;
    }
}

@media(max-width:540px) {
    .eb-about .ab-hero {
        border-radius:18px;
    }

    .eb-about .ab-hero-content {
        padding:36px 21px 27px;
    }

    .eb-about .ab-hero h1 {
        font-size:37px;
    }

    .eb-about .ab-hero-photo {
        height:260px;
        min-height:260px;
    }

    .eb-about .ab-photo-note {
        left:14px;
        bottom:14px;
    }

    .eb-about .ab-value-grid {
        grid-template-columns:1fr;
    }

    .eb-about .ab-portal {
        padding:25px 17px;
    }

    .eb-about .ab-closing {
        padding:27px 21px;
    }
}

@media(prefers-reduced-motion:reduce) {
    .eb-about *,
    .eb-about *::before,
    .eb-about *::after {
        animation:none!important;
        transition:none!important;
    }

    .eb-about.ab-motion .ab-reveal {
        opacity:1;
        transform:none;
    }
}
</style>

<div class="eb-about" id="ebAboutRoot">

    <!-- HERO -->
    <section class="ab-hero" aria-labelledby="abHeroTitle">

        <div class="ab-hero-content">

            <span class="ab-hero-tag">
                <span class="ab-spark"></span>
                About East Boom CHC
            </span>

            <h1 id="abHeroTitle">
                Healthcare built around
                <em>our community.</em>
            </h1>

            <p>
                Get to know East Boom Community Health Centre —
                the people-focused public healthcare facility
                serving Pietermaritzburg and the surrounding
                uMsunduzi communities.
            </p>

            <div class="ab-hero-actions">

                <a class="ab-btn ab-btn-lime"
                   href="#abWhoWeAre">
                    Discover our story &rarr;
                </a>

                <a class="ab-btn ab-btn-outline"
                   href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'>
                    Book an appointment
                </a>

            </div>
        </div>

        <div class="ab-hero-photo">

            <img src='<%= ResolveUrl("~/Images/hero-consultation.jpg") %>'
                 alt="Doctor talking with a patient"
                 fetchpriority="high" />

            <div class="ab-photo-note">
                <strong>Community. Compassion. Care.</strong>
                <small>East Boom CHC · Pietermaritzburg</small>
            </div>

        </div>
    </section>

    <div class="ab-content">

        <!-- WHO WE ARE -->
        <section class="ab-intro ab-reveal"
                 id="abWhoWeAre">

            <div class="ab-facility-photo">

                <img src='<%= ResolveUrl("~/Images/eastboom.jpg") %>'
                     alt="East Boom Community Health Centre building"
                     loading="lazy" />

                <span class="ab-facility-label">
                    East Boom CHC · Our facility
                </span>

            </div>

            <div class="ab-intro-copy">

                <span class="ab-kicker">Who we are</span>

                <h2 class="ab-title">
                    Local healthcare with a
                    <em>lasting purpose.</em>
                </h2>

                <p>
                    East Boom Community Health Centre is an
                    urban Community Health Centre within the
                    uMgungundlovu Health District, located in
                    the uMsunduzi Municipality in
                    Pietermaritzburg, KwaZulu-Natal.
                </p>

                <p>
                    The centre supports the community with a
                    range of primary healthcare services,
                    including prevention, treatment, health
                    promotion and rehabilitation.
                </p>

                <span class="ab-location">
                    &#9679; 541 Boom Street, Pietermaritzburg
                </span>

            </div>
        </section>

        <!-- VISION AND MISSION -->
        <section class="ab-identity ab-reveal">

            <article class="ab-philosophy-card">

                <span class="ab-philosophy-icon">◎</span>

                <h3>Our vision</h3>

                <p>
                    To deliver high-quality, integrated
                    community healthcare connected to the
                    district health system and the needs
                    of the uMsunduzi communities.
                </p>

            </article>

            <article class="ab-philosophy-card">

                <span class="ab-philosophy-icon">♡</span>

                <h3>Our mission</h3>

                <p>
                    To provide comprehensive preventive,
                    promotive, curative and rehabilitative
                    primary healthcare, guided by the
                    Batho Pele principles and the
                    Patients' Rights Charter.
                </p>

            </article>

        </section>

        <!-- VALUES -->
        <section class="ab-values ab-reveal">

            <div class="ab-section-heading">
                <span class="ab-kicker">What guides us</span>

                <h2 class="ab-title">
                    Our values in
                    <em>every interaction.</em>
                </h2>

                <p class="ab-description">
                    The principles of service, collaboration
                    and accountability described by the centre.
                </p>
            </div>

            <div class="ab-value-grid">

                <article class="ab-value-card">
                    <span class="ab-value-mark">01</span>
                    <h3>Trust &amp; integrity</h3>
                    <p>
                        Building relationships through
                        honesty and accountability.
                    </p>
                </article>

                <article class="ab-value-card">
                    <span class="ab-value-mark">02</span>
                    <h3>Teamwork &amp; respect</h3>
                    <p>
                        Working together while treating
                        others with dignity.
                    </p>
                </article>

                <article class="ab-value-card">
                    <span class="ab-value-mark">03</span>
                    <h3>Open communication</h3>
                    <p>
                        Encouraging transparency,
                        consultation and understanding.
                    </p>
                </article>

                <article class="ab-value-card">
                    <span class="ab-value-mark">04</span>
                    <h3>Learning &amp; improvement</h3>
                    <p>
                        Being willing to innovate and improve
                        how care is delivered.
                    </p>
                </article>

            </div>
        </section>

        <!-- WEBSITE FEATURES -->
        <section class="ab-portal ab-reveal">

            <div class="ab-section-heading">

                <span class="ab-kicker">
                    About this website
                </span>

                <h2 class="ab-title">
                    Making your clinic journey
                    <em>simpler.</em>
                </h2>

                <p class="ab-description">
                    The EastBoom Clinical Management System
                    makes key patient tasks easier to
                    access online.
                </p>

            </div>

            <div class="ab-feature-grid">

                <article class="ab-feature">

                    <span class="ab-feature-no">
                        01 / APPOINTMENTS
                    </span>

                    <h3>Plan your visit</h3>

                    <p>
                        Browse appointment dates,
                        select your care team and choose
                        from available time slots.
                    </p>

                    <a href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'>
                        Book an appointment &rarr;
                    </a>

                </article>

                <article class="ab-feature">

                    <span class="ab-feature-no">
                        02 / PATIENT PROFILE
                    </span>

                    <h3>Keep details up to date</h3>

                    <p>
                        Complete your patient information
                        before confirming a booking.
                    </p>

                    <a href='<%= ResolveUrl("~/Private/CompletePatientProfile.aspx") %>'>
                        Complete your profile &rarr;
                    </a>

                </article>

                <article class="ab-feature">

                    <span class="ab-feature-no">
                        03 / DASHBOARD
                    </span>

                    <h3>Stay organised</h3>

                    <p>
                        View your appointments and appointment
                        statuses through your patient dashboard.
                    </p>

                    <a href='<%= ResolveUrl("~/Private/Patient/PatientDashboard.aspx") %>'>
                        View your dashboard &rarr;
                    </a>

                </article>

            </div>

            <p class="ab-description" style="margin-top:18px;font-size:11px">
                Online appointment availability and booking
                rules are managed by your existing system.
                Not every clinical service can be booked online.
            </p>

        </section>

        <!-- FINAL SECTION -->
        <section class="ab-closing ab-reveal">

            <div>
                <h2>Your healthcare journey matters.</h2>

                <p>
                    Explore the clinic's information or take
                    the next step with your appointment.
                </p>
            </div>

            <a class="ab-btn ab-btn-lime"
               href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'>
                Book an appointment &rarr;
            </a>

        </section>

        <p class="ab-source-note">
            Facility information adapted from the
            <a href="https://www.kznhealth.gov.za/east-boom-chc/"
               target="_blank"
               rel="noopener noreferrer">
               KwaZulu-Natal Department of Health
            </a>.
            Healthcare consultation imagery is illustrative.
        </p>

    </div>
</div>

<script>
(function() {

    function initAboutPage() {

        var page = document.getElementById('ebAboutRoot');

        if (!page ||
            page.getAttribute('data-ready') === 'yes') {
            return;
        }

        page.setAttribute('data-ready', 'yes');

        var reduceMotion =
            window.matchMedia &&
            window.matchMedia(
                '(prefers-reduced-motion: reduce)'
            ).matches;

        if (reduceMotion ||
            !('IntersectionObserver' in window)) {
            return;
        }

        page.classList.add('ab-motion');

        var elements =
            page.querySelectorAll('.ab-reveal');

        var observer = new IntersectionObserver(
            function(entries) {

                entries.forEach(function(entry) {

                    if (entry.isIntersecting) {

                        entry.target.classList.add('ab-in');

                        observer.unobserve(entry.target);
                    }

                });

            },
            {
                threshold: 0.07,
                rootMargin: '0px 0px -18px 0px'
            }
        );

        Array.prototype.forEach.call(
            elements,
            function(element) {
                observer.observe(element);
            }
        );
    }

    if (document.readyState === 'loading') {

        document.addEventListener(
            'DOMContentLoaded',
            initAboutPage
        );

    } else {

        initAboutPage();

    }

})();
</script>

</asp:Content>
