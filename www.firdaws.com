<!DOCTYPE html>
<html lang="ar">
<head>
<meta charset="UTF-8">
<title>FIRDAWS - Plateforme de Transfert d’Argent</title>
<style>
body {
  font-family: Arial;
  background: #eef2f5;
}
.container {
  max-width: 900px;
  margin: auto;
  padding: 20px;
}
.header {
  text-align: center;
  margin-bottom: 20px;
}
.header h1 {
  color: #28a745;
}
.card {
  background: white;
  padding: 20px;
  margin-bottom: 15px;
  border-radius: 8px;
}
input, button {
  width: 100%;
  padding: 10px;
  margin: 5px 0;
}
button {
  background: #28a745;
  color: white;
  border: none;
}
.hidden { display: none; }
.balance { font-size: 22px; font-weight: bold; }
.warning {
  background: #fff3cd;
  padding: 10px;
  border-left: 5px solid #ffc107;
}
</style>
</head>

<body>

<div class="container">

  <div class="header">
    <h1>FIRDAWS BANK</h1>
    <p>منصة فرداوس لتحويل الأموال</p>
  </div>

  <div class="warning">
    ⚠️ FIRDAWS منصة تجريبية وتعليمية ولا تمثل مؤسسة مالية حقيقية
  </div>

  <!-- INSCRIPTION -->
  <div class="card" id="register">
    <h2>فتح حساب في FIRDAWS</h2>
    <input id="name" placeholder="الاسم الكامل">
    <input id="cin" placeholder="رقم البطاقة الوطنية (CIN)">
    <input id="account" placeholder="رقم الحساب البنكي FIRDAWS">
    <input id="phone" placeholder="رقم الهاتف">
    <button onclick="createAccount()">إنشاء الحساب</button>
  </div>

  <!-- DASHBOARD -->
  <div class="card hidden" id="dashboard">
    <h2>الحساب الشخصي - FIRDAWS</h2>
    <p><b>الاسم:</b> <span id="d_name"></span></p>
    <p><b>CIN:</b> <span id="d_cin"></span></p>
    <p><b>رقم الحساب:</b> <span id="d_account"></span></p>
    <p><b>الهاتف:</b> <span id="d_phone"></span></p>

    <p class="balance">الرصيد: <span id="balance">5000</span> MAD</p>
    <button onclick="logout()">تسجيل الخروج</button>
  </div>

  <!-- TRANSFER -->
  <div class="card hidden" id="transfer">
    <h2>تحويل الأموال عبر FIRDAWS</h2>
    <input id="targetAccount" placeholder="رقم حساب المستفيد">
    <input id="amount" type="number" placeholder="المبلغ">
    <button onclick="transferMoney()">تحويل</button>
    <p id="msg"></p>
  </div>

</div>

<script>
let user = {};
let balance = 5000;

function createAccount() {
  let name = d("name").value;
  let cin = d("cin").value;
  let account = d("account").value;
  let phone = d("phone").value;

  if(!name || !cin || !account || !phone) {
    alert("جميع المعلومات إجبارية");
    return;
  }

  user = { name, cin, account, phone };

  d("d_name").innerText = name;
  d("d_cin").innerText = cin;
  d("d_account").innerText = account + " (FIRDAWS)";
  d("d_phone").innerText = phone;

  toggle("register", true);
  toggle("dashboard", false);
  toggle("transfer", false);
}

function transferMoney() {
  let amount = Number(d("amount").value);
  let target = d("targetAccount").value;

  if(amount <= 0 || amount > balance) {
    alert("رصيد غير كافي");
    return;
  }

  balance -= amount;
  d("balance").innerText = balance;
  d("msg").innerText =
    `تم تحويل ${amount} MAD عبر FIRDAWS إلى الحساب ${target}`;
}

function logout() {
  location.reload();
}

function d(id){ return document.getElementById(id); }
function toggle(id, hide){
  d(id).classList[hide ? "add" : "remove"]("hidden");
}
</script>

</body>
</html>
