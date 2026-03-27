-- يمينك — Seed Data: Service Providers

INSERT INTO providers (name, name_ar, category, description_ar, phone, price_from, rating, coverage_cities, is_verified) VALUES

-- Nursing Providers
('Mobader Healthcare', 'مبادر للرعاية الصحية', 'nursing',
 'رعاية تمريضية منزلية شاملة: جروح، سرطان، زهايمر، عناية مزمنة. تغطية كاملة بالرياض.',
 '0112345678', 200, 4.8, ARRAY['riyadh'], true),

('Adeed Care', 'عضيد للرعاية', 'nursing',
 'رعاية مخصصة لكبار السن والأطفال الخدج. فريق متخصص ومدرب.',
 '0112345679', 180, 4.7, ARRAY['riyadh', 'jeddah'], true),

('Fakeeh Home Care', 'فقيه للرعاية المنزلية', 'nursing',
 'الذراع المنزلي لمجموعة فقيه للرعاية الصحية. أطباء وممرضون معتمدون.',
 '0126789012', 250, 4.9, ARRAY['jeddah', 'riyadh', 'medina'], true),

-- Transport Providers
('Naawn Medical Transport', 'نعاون للنقل الطبي', 'transport',
 'نقل طبي متخصص للمقعدين والحالات الخاصة. سيارات مجهزة بالكامل. تغطية جميع مناطق المملكة.',
 '0508765432', 120, 4.8, ARRAY['riyadh', 'jeddah', 'dammam', 'medina', 'taif'], true),

('Yusr Transport', 'يسر للتنقل', 'transport',
 'مرافقون مدربون وخدمات توصيل لجلسات العلاج الطبيعي والمراجعات الطبية.',
 '0507654321', 80, 4.6, ARRAY['riyadh', 'jeddah'], true),

('Mishaal Transport', 'مركز مشعل لخدمات النقل', 'transport',
 'نقل مرن للغسيل الكلوي والمتابعات بين المدن.',
 '0501234567', 100, 4.5, ARRAY['riyadh', 'dammam'], true),

('Hmm App Transport', 'تطبيق همم للنقل', 'transport',
 'تطبيق متخصص في نقل ذوي الاحتياجات الخاصة. حجز سهل عبر التطبيق.',
 '0509876543', 90, 4.7, ARRAY['riyadh', 'jeddah', 'dammam'], true),

-- Doctor Home Visit
('HomeCare Doctors', 'أطباء المنازل', 'doctor',
 'زيارات طبية منزلية من أطباء عامين ومتخصصين. متاح 7 أيام.',
 '0115555555', 350, 4.6, ARRAY['riyadh', 'jeddah'], true),

-- Physical Therapy
('Rehab at Home', 'العلاج الطبيعي المنزلي', 'therapy',
 'جلسات علاج طبيعي في المنزل من معالجين معتمدين.',
 '0504444444', 200, 4.7, ARRAY['riyadh'], true),

-- Companion
('Naawn Companion', 'رفيق نعاون', 'companion',
 'رفقاء مدربون لكبار السن — أنشطة، تسلية، دعم اجتماعي. مطابقة حسب الاهتمامات واللهجة.',
 '0503333333', 100, 4.8, ARRAY['riyadh', 'jeddah'], true);
