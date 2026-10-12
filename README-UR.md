# Udhaar Khata — شروع کرنے کی گائیڈ

یہ ایک mobile-first ویب ایپ کا ابتدائی مکمل پیکج ہے: گاہک، ادھار/وصولی، کاروباری فروخت/خریداری/اخراجات، خلاصہ، رپورٹ پرنٹ/PDF، WhatsApp اسٹیٹمنٹ، مقامی بیک اَپ اور PWA shell۔

## 1) Supabase کو کنفیگر کریں
1. Supabase project کھولیں: `https://supabase.com/dashboard/project/ewtddlcqocaojaoiwknm`
2. **SQL Editor** میں `supabase-schema.sql` کی پوری فائل چلا دیں۔
3. Project Settings → API Keys (یا Connect) سے **Publishable key** یا پرانی طرز کی **anon public key** کاپی کریں۔ `service_role` یا secret key ہرگز استعمال نہ کریں۔
4. `index.html` میں یہ لائن تلاش کریں:
   `const SUPABASE_ANON_KEY='PASTE_YOUR_SUPABASE_PUBLISHABLE_OR_ANON_KEY_HERE';`
   اس جگہ اپنی publishable/anon key ڈالیں۔ Project URL پہلے ہی شامل ہے۔
5. `index.html`, `manifest.webmanifest`, `sw.js` اور `supabase-schema.sql` کو GitHub repository میں اپ لوڈ کریں۔ Cloudflare Pages میں اسی repository کو connect کر کے deploy کریں۔

## 2) ضروری بات
- key شامل ہونے اور SQL schema چلنے کے بعد لاگ اِن/اکاؤنٹ بنانا دستیاب ہوگا۔
- لاگ اِن کے بعد گاہک/اندراج شامل کرنے، گاہک میں ترمیم کرنے اور اندراج حذف کرنے کے کلاؤڈ آپریشنز بھی جوڑے گئے ہیں۔ آف لائن کیے گئے نئے/بدلے ہوئے اندراجات کے لیے قابلِ اعتماد queue، دوبارہ کوشش اور sync-conflict حل ابھی مکمل نہیں؛ اس لیے اسے ابھی production-ready offline sync نہ سمجھیں۔
- ملازمین، کرداروں کی permissions، paid premium/subscriptions، scheduled reminders، اور full backup automation ابھی production میں نافذ نہیں ہیں۔
- Offline local data صرف اسی browser/device میں رہتا ہے۔ browser data صاف کرنے سے پہلے Settings یا Reports سے JSON backup ڈاؤن لوڈ کریں۔
- PDF کے لیے Reports میں **PDF / پرنٹ** دبائیں اور print dialog میں Save as PDF منتخب کریں۔
- WhatsApp statement کے لیے گاہک کے کھاتے میں WhatsApp اسٹیٹمنٹ دبائیں۔

## 3) سیکورٹی
- Supabase RLS policies ہر صارف کے rows کو الگ رکھتی ہیں۔
- Browser میں صرف publishable/anon key رکھی جا سکتی ہے؛ secret/service_role key نہیں۔
- live کاروباری استعمال سے پہلے cloud writes، permissions، automated tests اور backup/restore کی جانچ لازمی ہے۔
