<%@ Page Title="Symptom Checker" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SymptomChecker.aspx.cs" Inherits="WebApplication1.Private.Patient.SymptomChecker" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<style>
    /* Eastboom patient portal — scoped to this page so Site.Master is unaffected. */
    .sc-page { --ink:#19283a; --muted:#718092; --line:#e7eaf0; --teal:#1e704f; --red:#dc4029; --amber:#b7791f; background:#f6f9f7; color:var(--ink); padding:36px 16px 55px; font-family:system-ui,-apple-system,"Segoe UI",Arial,sans-serif; }
    .sc-page *, .sc-page *:before, .sc-page *:after {box-sizing:border-box;}
    .sc-wrap {max-width:820px; margin:0 auto;}
    .sc-eyebrow {color:#267455; text-transform:uppercase; letter-spacing:.16em; font-size:11px; font-weight:800; margin:0 0 10px;}
    .sc-head h1 {font-size:34px; line-height:1.13; letter-spacing:-.035em; margin:0 0 8px; font-weight:780;}
    .sc-head p {font-size:14px; color:var(--muted); margin:0 0 22px; max-width:620px;}
    .sc-card {background:#fff; border:1px solid var(--line); border-radius:17px; padding:24px; box-shadow:0 5px 17px rgba(32,54,87,.045); margin-bottom:18px;}
    .sc-card h2 {font-size:17px; margin:0 0 4px; font-weight:780; letter-spacing:-.02em;}
    .sc-sub {font-size:12px; color:var(--muted); margin:0 0 14px;}
    .sc-label {display:block; font-weight:750; font-size:12px; margin:0 0 8px;}
    .sc-text {display:block; width:100%; max-width:none; min-height:120px; padding:14px; border:1px solid #dce3ea; border-radius:12px; font:inherit; font-size:14px; line-height:1.5; resize:vertical; outline:none; color:#253347;}
    .sc-text:focus, .sc-select:focus {border-color:#318260; box-shadow:0 0 0 3px rgba(43,125,82,.13);}
    .sc-tip {font-size:12px; color:var(--muted); margin:8px 0 0;}
    .sc-examples {display:flex; gap:7px; flex-wrap:wrap; margin-top:10px; font-size:12px; color:var(--muted); align-items:center;}
    .sc-link {border:0; background:none; padding:0; color:#145a3e; font:inherit; font-size:12px; font-weight:700; cursor:pointer; text-decoration:underline;}
    .sc-chips {display:flex; flex-wrap:wrap; gap:7px;}
    .sc-chip {border:1px solid #dce3ea; background:#fff; color:#33455a; border-radius:50px; padding:7px 12px; font:inherit; font-size:12px; font-weight:650; cursor:pointer;}
    .sc-chip:hover {border-color:#1e704f; background:#f0f7f2;}
    .sc-chip[aria-pressed="true"] {border-color:#1e704f; background:#e3f2e8; color:#13583d; box-shadow:inset 0 0 0 1px #1e704f;}
    .sc-grid {display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-top:18px;}
    .sc-select {width:100%; max-width:none; min-height:42px; padding:10px 12px; border:1px solid #dce3ea; border-radius:9px; background:#fff; font:inherit; font-size:13px; color:#253347; outline:none;}
    .sc-check {display:flex; gap:9px; align-items:flex-start; margin-top:16px; font-size:12px; color:#405166; line-height:1.5;}
    .sc-check input {flex:none; width:16px; height:16px; margin-top:2px; accent-color:var(--teal);}
    .sc-check label {margin:0; font-weight:500;}
    .sc-go {display:block; width:100%; border:0; border-radius:10px; margin-top:20px; padding:14px; background:var(--teal); color:#fff; font-size:14px; font-weight:800; cursor:pointer; box-shadow:0 4px 10px rgba(17,81,51,.16);}
    .sc-go:hover {background:#145a3e;}
    .sc-error {display:none; color:var(--red); font-size:12px; font-weight:650; margin-top:10px;}
    .sc-error.show {display:block;}
    .sc-results {display:none;}
    .sc-results.show {display:block;}
    .sc-advice {border-radius:17px; padding:22px 24px; margin-bottom:18px; border:1px solid; }
    .sc-advice h2 {font-size:19px; margin:0 0 6px; font-weight:800; letter-spacing:-.02em;}
    .sc-advice p {font-size:14px; line-height:1.55; margin:0 0 6px;}
    .sc-advice ul {margin:8px 0 0; padding-left:19px; font-size:13px; line-height:1.6;}
    .sc-advice .tag {display:inline-block; font-size:10px; font-weight:800; letter-spacing:.12em; text-transform:uppercase; border-radius:50px; padding:4px 10px; margin-bottom:10px; color:#fff;}
    .sc-advice.emergency {background:#fdeeeb; border-color:#f3c5bd; color:#7d2415;}
    .sc-advice.emergency .tag {background:var(--red);}
    .sc-advice.book {background:#fff8e1; border-color:#f5dfa0; color:#6b4a0c;}
    .sc-advice.book .tag {background:var(--amber);}
    .sc-advice.selfcare {background:#e9f8f1; border-color:#bfe6d8; color:#0d5c4c;}
    .sc-advice.selfcare .tag {background:var(--teal);}
    .sc-actions {display:flex; gap:10px; flex-wrap:wrap; margin-top:16px;}
    .sc-btn {display:inline-flex; align-items:center; border-radius:9px; padding:11px 18px; font-size:13px; font-weight:800; text-decoration:none!important; border:0; cursor:pointer;}
    .sc-btn.solid {background:var(--red); color:#fff!important;}
    .sc-btn.solid:hover {background:#bc3522;}
    .sc-btn.teal {background:var(--teal); color:#fff!important;}
    .sc-btn.ghost {background:#fff; color:#405166!important; border:1px solid var(--line);}
    .sc-cond {border:1px solid var(--line); border-radius:12px; padding:15px 16px; margin-top:12px;}
    .sc-cond-top {display:flex; justify-content:space-between; align-items:center; gap:10px; flex-wrap:wrap;}
    .sc-cond h3 {font-size:15px; margin:0; font-weight:780;}
    .sc-match {font-size:10px; font-weight:800; border-radius:50px; padding:4px 9px; white-space:nowrap;}
    .sc-match.strong {background:#dbf5e9; color:#056d5b;}
    .sc-match.possible {background:#e8effc; color:#2553b3;}
    .sc-match.less {background:#f1f3f6; color:#5d6b7c;}
    .sc-cond p {font-size:13px; line-height:1.55; color:#405166; margin:8px 0 0;}
    .sc-cond .why {font-size:12px; color:var(--muted);}
    .sc-care {margin:10px 0 0; padding-left:19px; font-size:13px; line-height:1.65; color:#33455a;}
    .sc-care-title {font-size:12px; font-weight:780; margin:16px 0 0;}
    .sc-cond .sc-note {font-size:12px; font-weight:650; color:#96301f; background:#fdeeeb; border-radius:8px; padding:9px 11px; margin-top:12px;}
    .sc-cond .sc-src {font-size:11px; color:#84909c; margin-top:12px;}
    .sc-src a {color:#145a3e;}
    .sc-disclaimer {font-size:11px; line-height:1.6; color:#84909c; margin:0;}
    @media(max-width:650px){.sc-page{padding:22px 10px 40px}.sc-card{padding:18px}.sc-grid{grid-template-columns:1fr}.sc-head h1{font-size:28px}}
    .sc-back {display:inline-block; margin:0 0 16px; color:#256947!important; font-size:12px; font-weight:700; text-decoration:none!important;}
    .sc-back:hover {text-decoration:underline!important;}
</style>

<div class="sc-page" id="scRoot">
<div class="sc-wrap">
    <a class="sc-back" href='<%= ResolveUrl("~/Private/Patient/PatientDashboard.aspx") %>'>&#8592; Back to dashboard</a>
    <div class="sc-head">
        <p class="sc-eyebrow">Symptom checker</p>
        <h1>How are you feeling?</h1>
        <p>Describe your symptoms and see what they might point to, what you can do at home, and whether you should come in to the clinic.</p>
    </div>

    <div class="sc-card">
        <label class="sc-label" for="scText">Describe your symptoms</label>
        <textarea id="scText" class="sc-text" maxlength="1000" placeholder="e.g. I have had a sore throat and a runny nose since yesterday, with a slight fever and a headache."></textarea>
        <p class="sc-tip">Tip: say what you feel, where, and when it started.</p>
        <div class="sc-examples"><span>Try an example:</span>
            <button type="button" class="sc-link" data-sc-example="Sore throat, runny nose and sneezing since yesterday, with a mild headache.">Cold</button>
            <button type="button" class="sc-link" data-sc-example="Vomiting and watery diarrhoea since last night with stomach cramps. I feel weak and thirsty.">Upset stomach</button>
            <button type="button" class="sc-link" data-sc-example="It burns when I urinate and I need to go to the toilet all the time. Lower tummy pain too.">Bladder</button>
        </div>

        <p class="sc-label" style="margin-top:20px">Or tap the symptoms you have</p>
        <div id="scChips" class="sc-chips"></div>

        <div class="sc-grid">
            <div><label class="sc-label" for="scDuration">How long have you felt this way?</label>
                <select id="scDuration" class="sc-select">
                    <option value="1">Less than 1 day</option>
                    <option value="3" selected>1 to 3 days</option>
                    <option value="7">4 to 7 days</option>
                    <option value="14">1 to 2 weeks</option>
                    <option value="30">More than 2 weeks</option>
                </select></div>
            <div><label class="sc-label" for="scSeverity">How bad is it?</label>
                <select id="scSeverity" class="sc-select">
                    <option value="mild">Mild — I can carry on as normal</option>
                    <option value="moderate" selected>Moderate — it is affecting my day</option>
                    <option value="severe">Severe — I can hardly cope</option>
                </select></div>
        </div>
        <div class="sc-check">
            <input type="checkbox" id="scRisk" />
            <label for="scRisk">This is for a child under 5, someone over 65, someone who is pregnant, or someone with a long-term condition (such as diabetes, HIV, asthma, or heart or lung disease).</label>
        </div>

        <button type="button" id="scGo" class="sc-go">Check my symptoms</button>
        <div id="scError" class="sc-error" role="alert"></div>
    </div>

    <div id="scResults" class="sc-results" aria-live="polite">
        <div id="scAdvice"></div>
        <div class="sc-card" id="scCondCard">
            <h2>What it could be</h2>
            <p class="sc-sub">These are possibilities based on what you entered, not a diagnosis. Only a health worker who examines you can say what is wrong.</p>
            <div id="scConds"></div>
        </div>
    </div>

    <div class="sc-card">
        <p class="sc-disclaimer"><b>Please note:</b> this checker gives general health information only. It does not replace a doctor or nurse and cannot diagnose you. If you are worried, or you get worse, book an appointment or visit the clinic. In an emergency call an ambulance on <b>10177</b>, or <b>112</b> from a cell phone. Nothing you type here is saved.</p>
        <p class="sc-disclaimer" style="margin-top:8px">The advice for each condition was checked against public guidance from the NHS (UK National Health Service) and the World Health Organization in November 2026. Each result links to the page it was checked against.</p>
    </div>
</div>
</div>

<script>
(function () {
    var BOOK_URL = '<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>';

    /* ------------------------------------------------------------------
       KNOWLEDGE BASE — edit these lists to change what the checker knows.
       Everything runs in the browser: no database and nothing is stored.
       ------------------------------------------------------------------ */

    // Symptoms: label shown to the patient, words to look for in their text,
    // and chip:true to show it as a quick-pick button.
    var SYMPTOMS = {
        fever:        { label: 'Fever', chip: true, words: /fever|high temperature|temperature|feeling hot|hot body|burning up/ },
        chills:       { label: 'Chills or shivering', words: /chills|shiver|shaking with cold/ },
        cough:        { label: 'Cough', chip: true, words: /cough/ },
        phlegm:       { label: 'Coughing up mucus', words: /phlegm|mucus|sputum|chesty/ },
        sorethroat:   { label: 'Sore throat', chip: true, words: /sore throat|throat (is |feels )?(sore|pain|hurt)|painful throat|pain(ful)? (when|to) swallow|hurts to swallow|tonsil/ },
        runnynose:    { label: 'Runny or blocked nose', chip: true, words: /runny nose|running nose|blocked nose|stuffy nose|congest|nose is (runny|running|blocked)/ },
        sneezing:     { label: 'Sneezing', words: /sneez/ },
        headache:     { label: 'Headache', chip: true, words: /headache|head ache|head (is |hurts|pain)|sore head|migraine/ },
        bodyaches:    { label: 'Body or muscle aches', chip: true, words: /body (aches?|pains?)|muscle (aches?|pains?)|aching|sore muscles|joints? (pain|ache|sore)|my body is sore/ },
        fatigue:      { label: 'Tiredness or weakness', chip: true, words: /tired|fatigue|exhaust|weak\b|weakness|no energy|drained/ },
        breathless:   { label: 'Shortness of breath', chip: true, words: /short(ness)? of breath|out of breath|breathless|hard to breathe|difficult(y)? (in )?breathing|trouble breathing/ },
        wheeze:       { label: 'Wheezing or tight chest', words: /wheez|tight chest|chest (is |feels )?tight|whistling/ },
        smell:        { label: 'Loss of smell or taste', words: /(loss of|lost( my)?|no|can'?t|cannot) (sense of )?(smell|taste)/ },
        nausea:       { label: 'Nausea', chip: true, words: /nause|feel(ing)? sick|queasy|want to vomit/ },
        vomiting:     { label: 'Vomiting', chip: true, words: /vomit|throwing up|throw up|threw up/ },
        diarrhoea:    { label: 'Diarrhoea', chip: true, words: /diarrh|runny tummy|running stomach|runny stomach|loose stool|watery stool/ },
        stomachpain:  { label: 'Stomach pain or cramps', chip: true, words: /stomach (pain|ache|cramp)|tummy (pain|ache|cramp)|abdominal|belly (pain|ache)|stomach cramps|cramps|stomach ?ache/ },
        heartburn:    { label: 'Heartburn or burning in the chest', words: /heartburn|acid|reflux|burning in (my |the )?(chest|throat)|sour taste/ },
        appetite:     { label: 'Loss of appetite', words: /(no|loss of|lost( my)?|poor) appetite|not (eating|hungry)|don'?t feel like eating/ },
        thirst:       { label: 'Very thirsty or dry mouth', words: /thirst|dry mouth|dehydrat|dark urine/ },
        dizzy:        { label: 'Dizziness', chip: true, words: /dizz|light ?headed|head is spinning|spinning/ },
        burningurine: { label: 'Burning when passing urine', chip: true, words: /burn\w* (when|while) (i )?(urinat|pee|pass)|pain(ful)? (when|while|to) (i )?(urinat|pee|pass)|painful urinat|burning urin|hurts to pee|stings when/ },
        frequenturine:{ label: 'Passing urine often', words: /(urinat|pee|toilet|wee)\w* (a lot|often|all the time|frequent|many times)|frequent urinat|need to (go|pee|urinate) (all the time|often|a lot)/ },
        flankpain:    { label: 'Lower back or side pain', words: /lower back|back pain|side pain|pain in (my )?(side|back)|flank|lower (tummy|abdom|stomach)/ },
        rash:         { label: 'Skin rash', chip: true, words: /rash|spots|hives|bumps on (my )?skin|red patches/ },
        itching:      { label: 'Itching', words: /itch/ },
        itchyeyes:    { label: 'Itchy, red or watery eyes', words: /(itchy|watery|red|sore|sticky) eyes?|eyes? (are |is )?(itchy|itching|watery|red|sore|sticky)|pink ?eye/ },
        earpain:      { label: 'Ear pain', chip: true, words: /ear ?ache|ear (pain|hurts|is sore|is painful)|sore ear|pain in (my )?ear/ },
        facepain:     { label: 'Pain or pressure in the face', words: /sinus|face (pain|pressure)|pressure (in|around) (my )?(face|eyes|forehead|cheeks)|cheeks? (pain|hurt)/ },
        glands:       { label: 'Swollen glands in the neck', words: /swollen (glands|neck)|glands|lumps? in (my )?neck/ },
        light:        { label: 'Light or noise makes it worse', words: /sensitiv\w* to (light|noise|sound)|light hurts|bright light|flashing lights|aura/ },
        nightsweats:  { label: 'Night sweats', words: /night sweats?|sweat\w* at night/ },
        weightloss:   { label: 'Losing weight without trying', words: /los(ing|t|e) weight|weight loss/ }
    };

    // Danger signs. Any of these means emergency care, whatever else is entered.
    var RED_FLAGS = [
        { words: /chest pain|pain in (my |the )?chest|chest (is )?(hurting|hurts|sore)|pressure (in|on) (my |the )?chest|crushing/, text: 'Chest pain or pressure' },
        { words: /can'?t breathe|cannot breathe|struggling to breathe|gasping|blue lips|unable to breathe|choking/, text: 'Severe difficulty breathing' },
        { words: /cough\w* (up )?blood|blood (when|in) (i |my )?cough|vomit\w* blood|blood in (my )?vomit|coffee grounds?|ground coffee|green vomit/, text: 'Coughing up or vomiting blood, or green vomit' },
        { words: /(lips|skin|tongue|face) (is |are |have |has )?(turn\w* |gone |going )?(blue|grey|gray|very pale|blotchy)|(blue|grey|gray) (lips|skin|tongue)/, text: 'Blue, grey or very pale lips or skin' },
        { words: /(lost|lose|losing|loss of) (my )?(vision|sight|eyesight)|can'?t see|double vision|sudden\w* blurr/, text: 'Sudden loss of sight or double vision' },
        { words: /sudden\w*,? (and )?(severe|terrible|bad) (stomach|tummy|belly|abdominal) (pain|ache)|(severe|terrible) (stomach|tummy|belly|abdominal) (pain|ache) (that )?(came|started) (on )?sudden/, text: 'Sudden, severe stomach pain' },
        { words: /face (is )?droop|droop|slurred|can'?t (speak|talk|move)|weak\w* (on|in) one side|numb\w* (on|in) one side|one side of (my|the) (body|face)/, text: 'Possible signs of a stroke (face drooping, weak arm, slurred speech)' },
        { words: /faint|passed out|pass out|black(ed)? out|unconscious|collapse|seizure|fits?\b|convuls/, text: 'Fainting, collapse or a seizure' },
        { words: /confus|disorient|not making sense|very drowsy|hard to wake|can'?t wake/, text: 'Confusion or being very drowsy' },
        { words: /stiff neck|neck (is )?stiff/, text: 'A stiff neck (with fever or headache this can be serious)' },
        { words: /worst headache|sudden severe headache|thunderclap/, text: 'A sudden, very severe headache' },
        { words: /bleeding (a lot|heavily|won'?t stop|that won'?t stop)|heavy bleeding|severe bleeding|lot of blood/, text: 'Heavy bleeding' },
        { words: /swollen (lips|tongue|face|throat)|(lips|tongue|face|throat) (is |are )?swell|swelling of (the |my )?(lips|tongue|face|throat)/, text: 'Swelling of the face, lips, tongue or throat' },
        { words: /suicid|kill myself|end my life|harm myself|hurt myself|don'?t want to live/, text: 'Thoughts of harming yourself', crisis: true }
    ];

    // Signs that are not an emergency but should be seen at the clinic soon.
    var SEE_SOON = [
        { words: /blood in (my |the )?(urine|pee|stool|poo)|bloody (stool|urine|diarrh)|black stool/, text: 'Blood in your urine or stool' },
        { words: /can'?t keep (anything|fluids|water|food) down|not passing urine|no urine|hardly (any )?(pee|urine|urinat)|(haven'?t|have not|not) (peed|urinated|passed urine)/, text: 'Not keeping fluids down, or passing very little urine' },
        { words: /dizzy (when|every time) i stand|stand up .{0,20}dizz/, text: 'Dizziness when you stand up can be a sign of dehydration' }
    ];

    // Conditions. "core" symptoms count double; "see" = true means it should be seen at the clinic.
    // Each entry was checked against the public guidance named in "src" (NHS = UK National Health
    // Service, WHO = World Health Organization) in November 2026 and written in our own words.
    // If you change the advice, check it against the source again.
    var NHS = 'https://www.nhs.uk/conditions/';
    var CONDITIONS = [
        { name: 'Common cold', core: ['runnynose', 'sorethroat', 'sneezing'], other: ['cough', 'headache', 'fatigue'],
          src: ['NHS: Common cold', NHS + 'common-cold/'],
          about: 'A mild viral infection of the nose and throat. It comes on gradually and usually clears up by itself within 1 to 2 weeks. Antibiotics do not help.',
          care: ['Rest and drink plenty of fluids.', 'Paracetamol can ease a sore throat, headache or mild fever. Follow the directions on the pack.', 'Adults can gargle warm salt water to soothe the throat (not suitable for children).', 'Wash your hands often and cover coughs and sneezes. You can pass it on until your symptoms have gone.'],
          when: 'you are not better after 10 days, you have a fever for more than 3 days, your cough lasts more than 2 weeks, or you feel short of breath' },
        { name: 'Flu (influenza)', core: ['fever', 'bodyaches', 'fatigue'], other: ['chills', 'cough', 'headache', 'sorethroat', 'appetite'],
          src: ['NHS: Flu', NHS + 'flu/'],
          about: 'A viral infection that comes on quickly, within hours, and makes you feel much worse than a cold. It usually gets better in about a week.',
          care: ['Rest, sleep and keep warm. Stay home so that you do not spread it.', 'Drink plenty of water. Your urine should be light yellow or clear.', 'Paracetamol can bring down a fever and ease aches. Follow the directions on the pack.', 'Do not take paracetamol together with cold and flu remedies that also contain paracetamol.'],
          when: 'you are not improving after 7 days, you become short of breath, or you start to improve and then get worse again' },
        { name: 'COVID-19 or a similar viral infection', core: ['fever', 'cough', 'smell'], other: ['fatigue', 'sorethroat', 'headache', 'bodyaches', 'breathless'],
          src: ['NHS: Respiratory tract infections', NHS + 'respiratory-tract-infection/'],
          about: 'A viral infection of the nose, throat and chest. Most pass within 1 to 2 weeks, but they can be serious for older people and people with long-term conditions.',
          care: ['Rest and drink plenty of fluids.', 'Stay home and away from others while you have a fever or feel unwell.', 'Paracetamol can ease fever and aches. Follow the directions on the pack.'],
          when: 'you become short of breath, your symptoms are getting worse, or you are in a higher-risk group' },
        { name: 'Throat infection (tonsillitis)', core: ['sorethroat', 'fever', 'glands'], other: ['headache', 'appetite', 'fatigue'],
          src: ['NHS: Tonsillitis', NHS + 'tonsillitis/'],
          about: 'An infection of the throat or tonsils. It usually goes away in 3 to 4 days, sometimes up to a week. Most are caused by a virus; some are caused by bacteria and need treatment from the clinic.',
          care: ['Rest and drink plenty of fluids; cool drinks can soothe the throat.', 'Adults can gargle warm salt water (not suitable for children).', 'Paracetamol can ease pain and fever. Follow the directions on the pack.'],
          when: 'it has not gone after 1 week, the pain is so bad that you cannot eat or drink, or you keep getting throat infections' },
        { name: 'Sinus infection (sinusitis)', core: ['facepain', 'runnynose'], other: ['headache', 'fever', 'cough', 'fatigue'],
          src: ['NHS: Sinusitis', NHS + 'sinusitis-sinus-infection/'],
          about: 'Swelling of the air spaces behind your nose and cheeks, often after a cold. It usually clears up by itself within 2 to 3 weeks and is normally caused by a virus.',
          care: ['Get plenty of rest and drink plenty of fluids.', 'Rinse your nose with a salt water solution to ease the blockage.', 'Paracetamol can help with pain. Follow the directions on the pack.', 'Do not smoke, and avoid things that set off your allergies.'],
          when: 'you are not better after 3 weeks, your symptoms are severe, or you keep getting sinusitis' },
        { name: 'Hay fever or an allergy', core: ['sneezing', 'itchyeyes', 'runnynose'], other: ['itching', 'cough'],
          src: ['NHS: Hay fever', NHS + 'hay-fever/'],
          about: 'A reaction to something like pollen, dust or pets. It is not an infection, so there is usually no fever. It cannot be cured, but the symptoms can be eased.',
          care: ['Keep windows and doors shut when pollen or dust is bad.', 'Shower and change your clothes after being outside.', 'Dust with a damp cloth, and do not dry washing outside on high-pollen days.', 'Stay away from smoke. It makes the symptoms worse.', 'A pharmacist can advise on antihistamine tablets, drops or a nasal spray.'],
          when: 'pharmacy treatment is not helping, or it is affecting your sleep or breathing' },
        { name: 'Chest infection (bronchitis)', core: ['cough', 'phlegm'], other: ['fatigue', 'wheeze', 'sorethroat', 'fever', 'breathless'],
          src: ['NHS: Chest infection', NHS + 'chest-infection/'],
          about: 'An infection of the airways in your chest, often after a cold or flu. Most symptoms get better in 7 to 10 days, but the cough and mucus can last up to 3 weeks.',
          care: ['Get plenty of rest and drink lots of water to loosen the mucus.', 'A warm drink of honey and lemon can ease the cough (no honey for babies under 1).', 'Raise your head on extra pillows when you sleep.', 'Avoid smoke and do not smoke.'],
          when: 'your cough lasts more than 2 weeks (it should then be tested for TB), you feel very unwell, or you become short of breath' },
        { name: 'Pneumonia (lung infection)', core: ['cough', 'fever', 'breathless'], other: ['phlegm', 'chills', 'fatigue', 'appetite'],
          src: ['NHS: Pneumonia', NHS + 'pneumonia/'],
          about: 'A more serious infection of the lungs. It is usually treated with antibiotics, so it needs to be checked by a health worker soon.',
          care: ['Rest and drink plenty of fluids while you arrange to be seen.', 'Do not smoke.'],
          note: 'Go to an emergency unit or call 10177 if you are struggling to breathe, your lips or skin turn pale or blue, you cough up blood, or you suddenly feel confused.', see: true },
        { name: 'Asthma flare-up', core: ['wheeze', 'breathless'], other: ['cough'],
          src: ['NHS 111 Wales: Asthma', 'https://111.wales.nhs.uk/encyclopaedia/a/article/asthma'],
          about: 'Narrowing of the airways that causes wheezing, a tight chest, breathlessness and coughing, often worse at night.',
          care: ['Sit up straight and try to stay calm. Do not lie down.', 'If you have a reliever inhaler (usually blue), take one puff every 30 to 60 seconds, up to 10 puffs.', 'Even if it settles, be seen at the clinic the same day.'],
          note: 'Call an ambulance on 10177 (112 from a cell phone) if you feel worse at any point, you are no better after 10 puffs, or you do not have your inhaler.', see: true },
        { name: 'Tuberculosis (TB) — should be ruled out', core: ['cough', 'nightsweats', 'weightloss'], other: ['fever', 'fatigue', 'appetite'], minDays: 14,
          src: ['WHO: Tuberculosis', 'https://www.who.int/news-room/fact-sheets/detail/tuberculosis'],
          about: 'A cough that lasts more than 2 weeks, especially with fever, night sweats or weight loss, should always be tested for TB. TB can be cured: treatment is a course of antibiotics taken every day for about 6 months, and it must be finished.',
          care: ['Cover your mouth when you cough and keep windows open. TB spreads through the air.', 'Come to the clinic for a TB test as soon as you can.'], see: true },
        { name: 'Stomach bug (gastroenteritis) or food poisoning', core: ['diarrhoea', 'vomiting'], other: ['stomachpain', 'nausea', 'fever', 'appetite', 'fatigue'],
          src: ['NHS: Diarrhoea and vomiting', 'https://www.nhs.uk/symptoms/diarrhoea-and-vomiting/'],
          about: 'An infection or upset of the stomach and bowel. Vomiting usually stops in 1 to 2 days and diarrhoea within 5 to 7 days.',
          care: ['Stay home and rest. The most important thing is to drink lots of fluids; take small sips if you feel sick.', 'Oral rehydration solution from a pharmacy replaces the salts you lose.', 'Eat when you feel able to. Avoid fatty or spicy food.', 'Wash your hands with soap often, and do not prepare food for other people.', 'Stay off work or school until 2 days after the last time you were sick or had diarrhoea.'],
          when: 'the diarrhoea lasts more than 7 days or the vomiting more than 2 days, you see blood, you cannot keep fluids down, or you are passing very little urine' },
        { name: 'Dehydration', core: ['thirst', 'dizzy'], other: ['fatigue', 'headache', 'vomiting', 'diarrhoea'],
          src: ['NHS: Dehydration', NHS + 'dehydration/'],
          about: 'Your body has lost more fluid than it has taken in, often from vomiting, diarrhoea, heat or not drinking enough. Signs include thirst, dark strong-smelling urine, dizziness and tiredness.',
          care: ['Drink fluids. If you feel sick, start with small sips and slowly drink more.', 'If you have been vomiting or have diarrhoea, use oral rehydration solution from a pharmacy.', 'Avoid alcohol and drinks with caffeine, such as coffee and cola.'],
          when: 'you feel dizzy when you stand up and it does not pass, you are passing less urine than normal, or you feel unusually tired' },
        { name: 'Acid reflux or indigestion', core: ['heartburn'], other: ['nausea', 'stomachpain'],
          src: ['NHS: Heartburn and acid reflux', 'https://keepingmychesthealthy.bdct.nhs.uk/heartburn-acid-reflux/'],
          about: 'Stomach acid rising towards the throat, causing a burning feeling in the chest. It is usually worse after eating, when bending over or when lying down.',
          care: ['Eat smaller meals more often, and do not eat within 3 to 4 hours of going to bed.', 'Cut down on food and drink that sets it off, such as spicy or fatty food, coffee and alcohol.', 'Raise the head end of your bed a little.', 'A pharmacist can advise on antacids.'],
          when: 'you have heartburn most days for 3 weeks or more, food gets stuck in your throat, you are often sick, or you are losing weight without trying' },
        { name: 'Bladder or urine infection (UTI)', core: ['burningurine', 'frequenturine'], other: ['flankpain', 'fever', 'stomachpain'],
          src: ['NHS: Kidney infection (urinary infections)', NHS + 'kidney-infection/'],
          about: 'An infection in the bladder or urinary tract, causing burning when you pass urine and a need to go more often. It should be checked at the clinic, and may need antibiotics.',
          care: ['Drink plenty of water.', 'Do not hold in your urine; go when you need to.', 'Paracetamol can ease the pain. Follow the directions on the pack.'],
          note: 'Ask to be seen the same day if you also have a fever or shivering, pain in your back or side just under the ribs, blood in your urine, or you are pregnant. The infection may have reached the kidneys.', see: true },
        { name: 'Tension headache', core: ['headache'], other: ['fatigue'],
          src: ['NHS: Tension headaches', NHS + 'tension-headaches/'],
          about: 'The most common kind of headache, often linked to stress, tiredness, missed meals or not drinking enough.',
          care: ['Drink plenty of water and do not skip meals.', 'Rest and try to relax; stress makes headaches worse.', 'Paracetamol can help. Follow the directions on the pack (no aspirin for children under 16).', 'Cut down on tea, coffee and cola.'],
          when: 'you get several headaches a week, they are severe, or painkillers are not helping' },
        { name: 'Migraine', core: ['headache', 'light'], other: ['nausea', 'vomiting', 'dizzy'],
          src: ['NHS: Migraine', NHS + 'migraine/'],
          about: 'A throbbing headache, often on one side, that can come with nausea and sensitivity to light and sound. An attack usually lasts between 4 hours and 3 days.',
          care: ['Sleep or lie down in a darkened room.', 'If you take a painkiller, take it as soon as the headache starts. Follow the directions on the pack.', 'Drink water, and limit caffeine and alcohol.', 'Eat at regular times and try to avoid things you know set it off.'],
          when: 'an attack lasts longer than 3 days, you get them more than once a week, or they are getting worse' },
        { name: 'Ear infection', core: ['earpain'], other: ['fever', 'headache', 'runnynose'],
          src: ['NHS: Ear infections', NHS + 'ear-infections/'],
          about: 'An infection in the ear, common after a cold, especially in children. Most clear up within 3 days, though it can take up to a week.',
          care: ['Paracetamol can ease the pain. Follow the directions on the pack.', 'Hold a warm or cool cloth against the ear.', 'Keep the ear dry, and do not put cotton buds or anything else inside it.'],
          when: 'the earache is not getting better after 3 days, there is fluid coming from the ear, or you keep getting ear infections. A baby under 12 months should always be seen' },
        { name: 'Skin allergy or irritation', core: ['rash', 'itching'], other: [],
          src: ['NHS: Contact dermatitis', NHS + 'contact-dermatitis/'],
          about: 'A skin reaction to something you touched or used, such as a new soap, plant, metal or cream. It usually improves once you find and avoid the cause.',
          care: ['Stop using anything new that may have caused it.', 'Pat or tap the skin instead of scratching, and hold a cool, damp cloth on it.', 'Have cool or lukewarm baths, and use unperfumed soap and moisturiser.', 'A pharmacist can advise on a moisturising or soothing cream.'],
          when: 'it is severe, it is spreading, or it keeps coming back' },
        { name: 'Eye infection or irritation (conjunctivitis)', core: ['itchyeyes'], other: ['runnynose'],
          src: ['NHS: Conjunctivitis', NHS + 'conjunctivitis/'],
          about: 'Redness and irritation of the eye, from an infection or an allergy. It usually gets better in a couple of weeks without treatment.',
          care: ['Gently wash your eyelids with clean water (boiled and cooled) and clean cotton wool.', 'Wash your hands often and do not share towels or pillows.', 'Do not rub your eyes, and do not wear contact lenses until it has cleared.'],
          when: 'it has not cleared up within 7 days, your eye is painful, light hurts your eyes, or your sight changes' }
    ];

    /* --------------------------- the checker --------------------------- */

    var NEGATION = /\b(no|not|never|without|don'?t have|do not have|haven'?t( got)?|no more)\s+(\w+\s+){0,2}$/;

    // True when the words appear and are not written as "no fever", "without a cough", etc.
    function mentions(text, pattern) {
        var re = new RegExp(pattern.source, 'g'), m;
        while ((m = re.exec(text)) !== null) {
            if (!NEGATION.test(text.slice(Math.max(0, m.index - 30), m.index))) return true;
            if (m.index === re.lastIndex) re.lastIndex++;
        }
        return false;
    }

    // To connect a real AI service later, replace the body of this one function
    // (send "text" and the answers to the service and return the same shape).
    function analyse(text, picked, days, severity, risk) {
        text = ' ' + text.toLowerCase().replace(/[‘’]/g, "'") + ' ';
        var found = {};
        Object.keys(SYMPTOMS).forEach(function (id) {
            if (picked[id] || mentions(text, SYMPTOMS[id].words)) found[id] = true;
        });
        var flags = RED_FLAGS.filter(function (f) { return mentions(text, f.words); });
        var soon = SEE_SOON.filter(function (f) { return mentions(text, f.words); });

        var matches = [];
        CONDITIONS.forEach(function (c) {
            if (c.minDays && days < c.minDays) return;
            var coreHit = c.core.filter(function (s) { return found[s]; });
            var otherHit = c.other.filter(function (s) { return found[s]; });
            if (!coreHit.length) return;
            var score = (coreHit.length * 2 + otherHit.length) / (c.core.length * 2 + c.other.length * 0.5);
            if (c.core.length > 1 && coreHit.length < 2) score *= 0.55;
            // One symptom alone is never more than a "possible" match.
            if (c.core.length === 1) score = Math.min(score, 0.45 + 0.1 * otherHit.length);
            matches.push({ c: c, score: Math.min(score, 1), hit: coreHit.concat(otherHit) });
        });
        matches.sort(function (a, b) { return b.score - a.score; });
        matches = matches.filter(function (m) { return m.score >= 0.22; }).slice(0, 4);

        var reasons = [];
        soon.forEach(function (s) { reasons.push(s.text + '.'); });
        if (severity === 'severe') reasons.push('You said your symptoms are severe.');
        if (found.breathless) reasons.push('Shortness of breath should always be checked.');
        else if (found.wheeze) reasons.push('Wheezing or a tight chest should be checked.');
        if (days >= 14) reasons.push('Your symptoms have lasted more than a week.');
        else if (found.fever && days >= 7) reasons.push('A fever that lasts more than 3 days should be checked.');
        if (found.vomiting && days >= 7) reasons.push('Vomiting that lasts more than 2 days should be checked.');
        if ((found.burningurine || found.frequenturine) && (found.fever || found.chills || found.flankpain))
            reasons.push('Urine symptoms with a fever, shivering or pain in your back or side can mean a kidney infection. Ask to be seen today.');
        if (risk) reasons.push('You are in a group that should be seen sooner rather than later.');
        if (matches.length && matches[0].c.see && matches[0].score >= 0.4)
            reasons.push('Your symptoms could fit this condition, which needs to be checked at the clinic: ' + matches[0].c.name.split(' — ')[0] + '.');

        var level = flags.length ? 'emergency' : (reasons.length ? 'book' : 'selfcare');
        return { level: level, flags: flags, reasons: reasons, matches: matches, found: Object.keys(found) };
    }

    /* ----------------------------- the page ---------------------------- */

    function el(tag, cls, text) {
        var node = document.createElement(tag);
        if (cls) node.className = cls;
        if (text) node.textContent = text;
        return node;
    }
    function list(items) {
        var ul = el('ul');
        items.forEach(function (t) { ul.appendChild(el('li', '', t)); });
        return ul;
    }
    function link(cls, text, href) { var a = el('a', 'sc-btn ' + cls, text); a.href = href; return a; }

    function init() {
        var root = document.getElementById('scRoot');
        if (!root) return;
        var text = document.getElementById('scText');
        var chips = document.getElementById('scChips');
        var error = document.getElementById('scError');
        var picked = {};

        Object.keys(SYMPTOMS).forEach(function (id) {
            if (!SYMPTOMS[id].chip) return;
            var chip = el('button', 'sc-chip', SYMPTOMS[id].label);
            chip.type = 'button'; chip.setAttribute('aria-pressed', 'false');
            chip.addEventListener('click', function () {
                picked[id] = !picked[id];
                chip.setAttribute('aria-pressed', picked[id] ? 'true' : 'false');
            });
            chips.appendChild(chip);
        });
        Array.prototype.forEach.call(root.querySelectorAll('[data-sc-example]'), function (b) {
            b.addEventListener('click', function () { text.value = b.getAttribute('data-sc-example'); text.focus(); });
        });

        function show(result) {
            var advice = document.getElementById('scAdvice');
            var conds = document.getElementById('scConds');
            advice.innerHTML = ''; conds.innerHTML = '';
            // In an emergency with nothing else matched, show only the emergency advice.
            document.getElementById('scCondCard').style.display =
                (result.level === 'emergency' && !result.matches.length) ? 'none' : '';
            var box = el('div', 'sc-advice ' + result.level);
            var actions = el('div', 'sc-actions');

            if (result.level === 'emergency') {
                box.appendChild(el('span', 'tag', 'Emergency'));
                box.appendChild(el('h2', '', 'Get medical help now'));
                box.appendChild(el('p', '', 'What you described includes a danger sign. Do not wait for an appointment. Go to the nearest emergency unit, or call an ambulance on 10177 (112 from a cell phone).'));
                box.appendChild(list(result.flags.map(function (f) { return f.text; })));
                if (result.flags.some(function (f) { return f.crisis; }))
                    box.appendChild(el('p', '', 'You do not have to face this alone. You can talk to a counsellor at any time on the SADAG Suicide Crisis Helpline: 0800 567 567 (free).')).style.marginTop = '10px';
                actions.appendChild(link('solid', 'Call 10177', 'tel:10177'));
                actions.appendChild(link('ghost', 'Call 112 from a cell phone', 'tel:112'));
            } else if (result.level === 'book') {
                box.appendChild(el('span', 'tag', 'See the clinic'));
                box.appendChild(el('h2', '', 'Please book an appointment'));
                box.appendChild(el('p', '', 'You should be seen by a doctor or nurse soon, for these reasons:'));
                box.appendChild(list(result.reasons));
                box.appendChild(el('p', '', 'If you get worse while you wait, or have chest pain or trouble breathing, go to the nearest emergency unit or call 10177.')).style.marginTop = '10px';
                actions.appendChild(link('solid', 'Book an appointment  →', BOOK_URL));
            } else {
                box.appendChild(el('span', 'tag', 'Care at home'));
                box.appendChild(el('h2', '', 'You can probably look after this at home'));
                box.appendChild(el('p', '', result.matches.length
                    ? 'Nothing you entered points to something urgent. Follow the guidelines below, and book an appointment if you do not improve or you get worse.'
                    : 'Nothing you entered points to something urgent. Rest, drink plenty of fluids, and book an appointment if you do not improve in a few days or you get worse.'));
                actions.appendChild(link('teal', 'Book an appointment anyway', BOOK_URL));
            }
            box.appendChild(actions);
            advice.appendChild(box);

            if (!result.matches.length) {
                conds.appendChild(el('p', 'sc-sub', result.found.length
                    ? 'Your symptoms do not clearly match one of the common conditions this checker knows about. If they continue, book an appointment so that a health worker can examine you.'
                    : 'We could not pick out any symptoms from what you wrote. Try describing them in different words, or tap the symptoms above.'));
            }
            result.matches.forEach(function (m) {
                var card = el('div', 'sc-cond');
                var top = el('div', 'sc-cond-top');
                top.appendChild(el('h3', '', m.c.name));
                var strength = m.score >= 0.6 ? ['strong', 'Strong match'] : m.score >= 0.38 ? ['possible', 'Possible match'] : ['less', 'Less likely'];
                top.appendChild(el('span', 'sc-match ' + strength[0], strength[1]));
                card.appendChild(top);
                card.appendChild(el('p', '', m.c.about));
                card.appendChild(el('p', 'why', 'Because you mentioned: ' + m.hit.map(function (s) { return SYMPTOMS[s].label.toLowerCase(); }).join(', ') + '.'));
                if (result.level !== 'emergency') {
                    card.appendChild(el('p', 'sc-care-title', m.c.see ? 'Until you are seen' : 'What you can do'));
                    var care = list(m.c.care); care.className = 'sc-care';
                    card.appendChild(care);
                    if (m.c.when) card.appendChild(el('p', 'why', 'Book an appointment if ' + m.c.when + '.'));
                    if (m.c.note) card.appendChild(el('p', 'sc-note', m.c.note));
                }
                if (m.c.src) {
                    var source = el('p', 'sc-src', 'Checked against ');
                    var a = el('a', '', m.c.src[0]);
                    a.href = m.c.src[1]; a.target = '_blank'; a.rel = 'noopener';
                    source.appendChild(a);
                    card.appendChild(source);
                }
                conds.appendChild(card);
            });

            document.getElementById('scResults').classList.add('show');
            advice.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }

        document.getElementById('scGo').addEventListener('click', function () {
            var anyPicked = Object.keys(picked).some(function (k) { return picked[k]; });
            if (text.value.trim().length < 3 && !anyPicked) {
                error.textContent = 'Describe how you feel, or tap at least one symptom.';
                error.classList.add('show'); text.focus(); return;
            }
            error.classList.remove('show');
            show(analyse(text.value, picked,
                parseInt(document.getElementById('scDuration').value, 10),
                document.getElementById('scSeverity').value,
                document.getElementById('scRisk').checked));
        });

        window.scAnalyse = analyse;   // handy for testing in the browser console
    }
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
</script>
</asp:Content>
