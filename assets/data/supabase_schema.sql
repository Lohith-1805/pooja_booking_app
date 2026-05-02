-- ============================================================
-- POOJA PLATFORM - SUPABASE SQL SCHEMA (v2 - Production Grade)
-- Run this in your Supabase SQL Editor
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================
-- USERS
-- ============================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  auth_id UUID UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL DEFAULT '',
  phone TEXT UNIQUE NOT NULL,
  email TEXT,
  role TEXT NOT NULL DEFAULT 'devotee' CHECK (role IN ('devotee','pandit','temple_admin','super_admin')),
  avatar_url TEXT,
  city TEXT,
  location_lat DOUBLE PRECISION,
  location_lng DOUBLE PRECISION,
  fcm_token TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- ADDRESSES (FIX #6 - reusable, geo-ready)
-- ============================
CREATE TABLE IF NOT EXISTS addresses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  label TEXT DEFAULT 'Home',
  full_address TEXT NOT NULL,
  city TEXT,
  state TEXT,
  pincode TEXT,
  lat DOUBLE PRECISION,
  lng DOUBLE PRECISION,
  is_default BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- PANDITS
-- ============================
CREATE TABLE IF NOT EXISTS pandits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  bio TEXT,
  experience_years INTEGER DEFAULT 0,
  languages TEXT[] DEFAULT '{}',
  -- specializations TEXT[] REMOVED (FIX #2 - replaced by pandit_poojas table)
  rating DOUBLE PRECISION DEFAULT 0.0,
  total_reviews INTEGER DEFAULT 0,
  is_verified BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  travel_radius_km DOUBLE PRECISION DEFAULT 20,
  photo_url TEXT,
  city TEXT,
  location_lat DOUBLE PRECISION,
  location_lng DOUBLE PRECISION,
  base_price INTEGER DEFAULT 1500,
  phone TEXT,
  aadhar_verified BOOLEAN DEFAULT FALSE,
  aadhar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- WALLETS (IMPROVEMENT #3)
-- ============================
CREATE TABLE IF NOT EXISTS wallets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pandit_id UUID NOT NULL UNIQUE REFERENCES pandits(id) ON DELETE CASCADE,
  balance INTEGER DEFAULT 0,
  total_earned INTEGER DEFAULT 0,
  total_withdrawn INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS wallet_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  wallet_id UUID NOT NULL REFERENCES wallets(id) ON DELETE CASCADE,
  booking_id UUID,
  type TEXT NOT NULL CHECK (type IN ('credit','debit','withdrawal','refund')),
  amount INTEGER NOT NULL,
  status TEXT DEFAULT 'completed' CHECK (status IN ('pending','completed','failed')),
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- TEMPLES
-- ============================
CREATE TABLE IF NOT EXISTS temples (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  admin_user_id UUID REFERENCES users(id),
  name TEXT NOT NULL,
  description TEXT,
  address TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  location_lat DOUBLE PRECISION,
  location_lng DOUBLE PRECISION,
  image_url TEXT,
  rating DOUBLE PRECISION DEFAULT 0.0,
  total_reviews INTEGER DEFAULT 0,
  is_verified BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  phone TEXT,
  opening_time TIME DEFAULT '06:00:00',   -- FIX #3: TIME not TEXT
  closing_time TIME DEFAULT '20:00:00',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- POOJA MASTER (FIX #1 - decoupled from temple)
-- ============================
CREATE TABLE IF NOT EXISTS pooja_master (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name_en TEXT NOT NULL,
  name_te TEXT,
  name_hi TEXT,
  category TEXT DEFAULT 'both' CHECK (category IN ('temple','home','both')),
  description TEXT,
  image_url TEXT,
  requirements TEXT[] DEFAULT '{}',
  default_duration_mins INTEGER DEFAULT 60,
  base_price INTEGER NOT NULL DEFAULT 1000,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- TEMPLE POOJAS (FIX #1 - temple-specific config)
-- ============================
CREATE TABLE IF NOT EXISTS temple_poojas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  temple_id UUID NOT NULL REFERENCES temples(id) ON DELETE CASCADE,
  pooja_id UUID NOT NULL REFERENCES pooja_master(id) ON DELETE CASCADE,
  price INTEGER NOT NULL,
  duration_mins INTEGER DEFAULT 60,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(temple_id, pooja_id)
);

-- ============================
-- PANDIT POOJAS (FIX #2 - normalized skills)
-- ============================
CREATE TABLE IF NOT EXISTS pandit_poojas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pandit_id UUID NOT NULL REFERENCES pandits(id) ON DELETE CASCADE,
  pooja_id UUID NOT NULL REFERENCES pooja_master(id) ON DELETE CASCADE,
  price INTEGER,
  duration_mins INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(pandit_id, pooja_id)
);

-- ============================
-- TEMPLE SLOTS
-- ============================
CREATE TABLE IF NOT EXISTS temple_slots (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  temple_id UUID NOT NULL REFERENCES temples(id) ON DELETE CASCADE,
  pooja_id UUID NOT NULL REFERENCES pooja_master(id) ON DELETE CASCADE,
  slot_date DATE NOT NULL,
  start_time TIME NOT NULL,   -- FIX #3
  end_time TIME NOT NULL,
  capacity INTEGER DEFAULT 1,
  booked_count INTEGER DEFAULT 0,
  price INTEGER NOT NULL,
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- PANDIT AVAILABILITY
-- ============================
CREATE TABLE IF NOT EXISTS pandit_availability (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pandit_id UUID NOT NULL REFERENCES pandits(id) ON DELETE CASCADE,
  avail_date DATE NOT NULL,
  start_time TIME NOT NULL,   -- FIX #3
  end_time TIME NOT NULL,
  is_booked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(pandit_id, avail_date, start_time)
);

-- ============================
-- BOOKINGS (FIX #4 + #7 improvements)
-- ============================
CREATE TABLE IF NOT EXISTS bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  devotee_id UUID NOT NULL REFERENCES users(id),
  pandit_id UUID REFERENCES pandits(id),
  temple_id UUID REFERENCES temples(id),
  pooja_id UUID NOT NULL REFERENCES pooja_master(id),
  slot_id UUID REFERENCES temple_slots(id),
  address_id UUID REFERENCES addresses(id),    -- IMPROVEMENT #1
  booking_type TEXT NOT NULL CHECK (booking_type IN ('temple','home')),
  booking_date DATE NOT NULL,
  start_time TIME NOT NULL,   -- FIX #3
  end_time TIME,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending','confirmed','completed','cancelled','rejected')),
  gotram TEXT,
  nakshatram TEXT,
  address TEXT,               -- kept as fallback for freeform address
  total_amount INTEGER NOT NULL,
  commission_percentage NUMERIC(5,2) DEFAULT 10.00,  -- IMPROVEMENT #4
  commission_amount INTEGER DEFAULT 0,
  platform_fee INTEGER DEFAULT 0,
  pandit_amount INTEGER DEFAULT 0,
  special_instructions TEXT,
  cancellation_reason TEXT,
  cancelled_at TIMESTAMPTZ,       -- IMPROVEMENT #2
  refund_amount INTEGER,
  refund_status TEXT DEFAULT 'none' CHECK (refund_status IN ('none','pending','processed')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- FIX #4: booking consistency constraint
  CONSTRAINT chk_booking_type CHECK (
    (booking_type = 'home'   AND pandit_id IS NOT NULL AND temple_id IS NULL  AND slot_id IS NULL)
    OR
    (booking_type = 'temple' AND temple_id IS NOT NULL AND slot_id IS NOT NULL AND pandit_id IS NULL)
  )
);

-- ============================
-- PAYMENTS
-- ============================
CREATE TABLE IF NOT EXISTS payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id UUID NOT NULL REFERENCES bookings(id),
  razorpay_order_id TEXT,
  razorpay_payment_id TEXT,
  razorpay_signature TEXT,
  amount INTEGER NOT NULL,
  currency TEXT DEFAULT 'INR',
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending','success','failed','refunded')),
  refund_amount INTEGER,
  refund_reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- REVIEWS (FIX #5 - typed UUID columns)
-- ============================
CREATE TABLE IF NOT EXISTS reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id UUID NOT NULL REFERENCES bookings(id) UNIQUE,
  reviewer_id UUID NOT NULL REFERENCES users(id),
  pandit_id UUID REFERENCES pandits(id),    -- FIX #5
  temple_id UUID REFERENCES temples(id),    -- FIX #5
  rating DOUBLE PRECISION NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  is_visible BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),

  -- FIX #5: exactly one of pandit_id or temple_id must be set
  CONSTRAINT chk_review_target CHECK (
    (pandit_id IS NOT NULL AND temple_id IS NULL)
    OR
    (temple_id IS NOT NULL AND pandit_id IS NULL)
  )
);

-- ============================
-- NOTIFICATIONS
-- ============================
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  type TEXT NOT NULL,
  data JSONB DEFAULT '{}',
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- BANNERS
-- ============================
CREATE TABLE IF NOT EXISTS banners (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  subtitle TEXT,
  image_url TEXT,
  action_url TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- AUDIT LOGS (IMPROVEMENT #5)
-- ============================
CREATE TABLE IF NOT EXISTS audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  action TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id UUID,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- INDEXES
-- ============================
CREATE INDEX IF NOT EXISTS idx_bookings_devotee    ON bookings(devotee_id);
CREATE INDEX IF NOT EXISTS idx_bookings_pandit     ON bookings(pandit_id);
CREATE INDEX IF NOT EXISTS idx_bookings_temple     ON bookings(temple_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status     ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_date       ON bookings(booking_date);
CREATE INDEX IF NOT EXISTS idx_pandits_city        ON pandits(city);
CREATE INDEX IF NOT EXISTS idx_pandits_verified    ON pandits(is_verified);
CREATE INDEX IF NOT EXISTS idx_temples_city        ON temples(city);
CREATE INDEX IF NOT EXISTS idx_temple_slots_date   ON temple_slots(slot_date);
CREATE INDEX IF NOT EXISTS idx_notifications_user  ON notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_pandit_poojas_pooja ON pandit_poojas(pooja_id);
CREATE INDEX IF NOT EXISTS idx_temple_poojas_temple ON temple_poojas(temple_id);
CREATE INDEX IF NOT EXISTS idx_reviews_pandit      ON reviews(pandit_id);
CREATE INDEX IF NOT EXISTS idx_reviews_temple      ON reviews(temple_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user     ON audit_logs(user_id, created_at);
CREATE INDEX IF NOT EXISTS idx_addresses_user      ON addresses(user_id);

-- ============================
-- ROW LEVEL SECURITY
-- ============================
ALTER TABLE users               ENABLE ROW LEVEL SECURITY;
ALTER TABLE addresses           ENABLE ROW LEVEL SECURITY;
ALTER TABLE pandits             ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallets             ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallet_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE temples             ENABLE ROW LEVEL SECURITY;
ALTER TABLE pooja_master        ENABLE ROW LEVEL SECURITY;
ALTER TABLE temple_poojas       ENABLE ROW LEVEL SECURITY;
ALTER TABLE pandit_poojas       ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings            ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments            ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews             ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications       ENABLE ROW LEVEL SECURITY;
ALTER TABLE temple_slots        ENABLE ROW LEVEL SECURITY;
ALTER TABLE pandit_availability ENABLE ROW LEVEL SECURITY;

-- Users
CREATE POLICY "Users read own profile"   ON users FOR SELECT USING (auth.uid() = auth_id);
CREATE POLICY "Users update own profile" ON users FOR UPDATE USING (auth.uid() = auth_id);
CREATE POLICY "Service role users"       ON users FOR ALL    USING (auth.role() = 'service_role');

-- Addresses
CREATE POLICY "Users read own addresses"   ON addresses FOR SELECT USING (user_id = (SELECT id FROM users WHERE auth_id = auth.uid()));
CREATE POLICY "Users manage own addresses" ON addresses FOR ALL    USING (user_id = (SELECT id FROM users WHERE auth_id = auth.uid()));

-- Pandits
CREATE POLICY "Public read verified pandits" ON pandits FOR SELECT USING (is_verified = TRUE AND is_active = TRUE);
CREATE POLICY "Pandits update own profile"   ON pandits FOR UPDATE USING (user_id = (SELECT id FROM users WHERE auth_id = auth.uid()));
CREATE POLICY "Service role pandits"         ON pandits FOR ALL    USING (auth.role() = 'service_role');

-- Wallets
CREATE POLICY "Pandits read own wallet" ON wallets FOR SELECT USING (
  pandit_id IN (SELECT id FROM pandits WHERE user_id = (SELECT id FROM users WHERE auth_id = auth.uid()))
);
CREATE POLICY "Service role wallets" ON wallets FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Pandits read own transactions" ON wallet_transactions FOR SELECT USING (
  wallet_id IN (SELECT id FROM wallets WHERE pandit_id IN (SELECT id FROM pandits WHERE user_id = (SELECT id FROM users WHERE auth_id = auth.uid())))
);
CREATE POLICY "Service role wallet_transactions" ON wallet_transactions FOR ALL USING (auth.role() = 'service_role');

-- Temples
CREATE POLICY "Public read verified temples" ON temples FOR SELECT USING (is_verified = TRUE AND is_active = TRUE);
CREATE POLICY "Service role temples"         ON temples FOR ALL    USING (auth.role() = 'service_role');

-- Pooja master
CREATE POLICY "Public read active poojas" ON pooja_master  FOR SELECT USING (is_active = TRUE);
CREATE POLICY "Service role pooja_master" ON pooja_master  FOR ALL    USING (auth.role() = 'service_role');

-- Temple poojas
CREATE POLICY "Public read temple_poojas" ON temple_poojas FOR SELECT USING (is_active = TRUE);
CREATE POLICY "Service role temple_poojas" ON temple_poojas FOR ALL   USING (auth.role() = 'service_role');

-- Pandit poojas
CREATE POLICY "Public read pandit_poojas"  ON pandit_poojas FOR SELECT USING (TRUE);
CREATE POLICY "Service role pandit_poojas" ON pandit_poojas FOR ALL   USING (auth.role() = 'service_role');

-- Bookings
CREATE POLICY "Devotees see own bookings"    ON bookings FOR SELECT USING (devotee_id = (SELECT id FROM users WHERE auth_id = auth.uid()));
CREATE POLICY "Pandits see their bookings"   ON bookings FOR SELECT USING (pandit_id IN (SELECT id FROM pandits WHERE user_id = (SELECT id FROM users WHERE auth_id = auth.uid())));
CREATE POLICY "Devotees create bookings"     ON bookings FOR INSERT WITH CHECK (devotee_id = (SELECT id FROM users WHERE auth_id = auth.uid()));
CREATE POLICY "Service role bookings"        ON bookings FOR ALL    USING (auth.role() = 'service_role');

-- Temple slots & availability
CREATE POLICY "Public read slots"        ON temple_slots        FOR SELECT USING (TRUE);
CREATE POLICY "Service role slots"       ON temple_slots        FOR ALL    USING (auth.role() = 'service_role');
CREATE POLICY "Public read availability" ON pandit_availability FOR SELECT USING (TRUE);
CREATE POLICY "Service role availability" ON pandit_availability FOR ALL   USING (auth.role() = 'service_role');

-- Notifications
CREATE POLICY "Users see own notifications"    ON notifications FOR SELECT USING (user_id = (SELECT id FROM users WHERE auth_id = auth.uid()));
CREATE POLICY "Users update own notifications" ON notifications FOR UPDATE USING (user_id = (SELECT id FROM users WHERE auth_id = auth.uid()));

-- ============================
-- SEED DATA
-- ============================

-- Demo Temples
INSERT INTO temples (id, name, description, address, city, state, location_lat, location_lng, rating, total_reviews, is_verified, opening_time, closing_time) VALUES
('11111111-1111-1111-1111-111111111111', 'Sri Venkateswara Swamy Temple', 'One of the most sacred temples in Hyderabad with daily poojas and homams.', 'Chilkur, Ranga Reddy', 'Hyderabad', 'Telangana', 17.3200, 78.2900, 4.9, 1253, TRUE, '05:30:00', '21:00:00'),
('22222222-2222-2222-2222-222222222222', 'Birla Mandir', 'Beautiful white marble temple on hilltop with stunning city views.', 'Naubat Pahad, Khairatabad', 'Hyderabad', 'Telangana', 17.4062, 78.4691, 4.7, 892, TRUE, '07:00:00', '20:00:00'),
('33333333-3333-3333-3333-333333333333', 'Keesara Gutta Temple', 'Ancient Shiva temple famous for Shivaratri and daily abhishekams.', 'Keesara, Medchal', 'Hyderabad', 'Telangana', 17.5500, 78.6000, 4.8, 634, TRUE, '06:00:00', '20:30:00')
ON CONFLICT (id) DO NOTHING;

-- Demo Pooja Master
INSERT INTO pooja_master (id, name_en, name_te, name_hi, category, description, requirements, default_duration_mins, base_price) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Satyanarayana Puja',  'సత్యనారాయణ పూజ', 'सत्यनारायण पूजा', 'both', 'Auspicious puja for well-being and prosperity.', ARRAY['Flowers','Fruits','Milk','Honey'], 120, 2500),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Griha Pravesh',       'గృహ ప్రవేశం',      'गृह प्रवेश',       'home', 'Housewarming ceremony for new home blessings.',  ARRAY['Flowers','Kalash','Rice','Coconut'],  180, 5000),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Lakshmi Puja',        'లక్ష్మీ పూజ',       'लक्ष्मी पूजा',    'both', 'Goddess Lakshmi puja for wealth and prosperity.', ARRAY['Red flowers','Lotus','Coins','Sweets'], 90, 1500),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'Navagraha Homam',     'నవగ్రహ హోమం',       'नवग्रह होम',      'both', 'Powerful homam to appease nine planetary deities.', ARRAY['Havan samgri','Ghee','9 grains','Flowers'], 240, 7500),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ganesh Puja',         'గణేశ పూజ',          'गणेश पूजा',       'both', 'Remove obstacles with Lord Ganesha blessings.',  ARRAY['Durva grass','Modak','Red flowers'], 60, 1000),
('ffffffff-ffff-ffff-ffff-ffffffffffff', 'Rudrabhishek',        'రుద్రాభిషేకం',      'रुद्राभिषेक',     'both', 'Sacred abhishekam to Lord Shiva.',              ARRAY['Milk','Honey','Curd','Ghee','Bilva leaves'], 150, 4000)
ON CONFLICT (id) DO NOTHING;

-- Demo Temple Poojas (link temples to poojas with temple-specific pricing)
INSERT INTO temple_poojas (temple_id, pooja_id, price, duration_mins) VALUES
('11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2500, 120),
('11111111-1111-1111-1111-111111111111', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 1500,  90),
('11111111-1111-1111-1111-111111111111', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 8000, 240),
('11111111-1111-1111-1111-111111111111', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 4000, 150),
('22222222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 3000, 120),
('22222222-2222-2222-2222-222222222222', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 1200,  60),
('33333333-3333-3333-3333-333333333333', 'ffffffff-ffff-ffff-ffff-ffffffffffff', 5000, 150),
('33333333-3333-3333-3333-333333333333', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 9000, 240)
ON CONFLICT (temple_id, pooja_id) DO NOTHING;

-- Demo Temple Slots (Venkateswara, next 7 days)
INSERT INTO temple_slots (temple_id, pooja_id, slot_date, start_time, end_time, capacity, price, is_available)
SELECT '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  CURRENT_DATE + s, '09:00:00', '11:00:00', 5, 2500, TRUE
FROM generate_series(1, 7) AS s
ON CONFLICT DO NOTHING;

INSERT INTO temple_slots (temple_id, pooja_id, slot_date, start_time, end_time, capacity, price, is_available)
SELECT '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  CURRENT_DATE + s, '14:00:00', '16:00:00', 5, 2500, TRUE
FROM generate_series(1, 7) AS s
ON CONFLICT DO NOTHING;

-- Demo Banners
INSERT INTO banners (title, subtitle, is_active, display_order) VALUES
('Book Poojas Online', 'Temple Poojas & Home Poojas', TRUE, 1),
('Festival Special',   'Extra poojas this Diwali',    TRUE, 2),
('New Pandits',        'Expert pandits in your city', TRUE, 3)
ON CONFLICT DO NOTHING;

-- ============================
-- FUNCTIONS & TRIGGERS
-- ============================

-- Auto-create wallet on pandit insert (IMPROVEMENT #3)
CREATE OR REPLACE FUNCTION create_pandit_wallet()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO wallets (pandit_id) VALUES (NEW.id)
  ON CONFLICT (pandit_id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_create_pandit_wallet
AFTER INSERT ON pandits
FOR EACH ROW EXECUTE FUNCTION create_pandit_wallet();

-- Update pandit rating (FIX #5 - uses typed pandit_id column)
CREATE OR REPLACE FUNCTION update_pandit_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE pandits SET
    rating        = (SELECT AVG(rating) FROM reviews WHERE pandit_id = NEW.pandit_id),
    total_reviews = (SELECT COUNT(*)    FROM reviews WHERE pandit_id = NEW.pandit_id)
  WHERE id = NEW.pandit_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_pandit_rating
AFTER INSERT OR UPDATE ON reviews
FOR EACH ROW WHEN (NEW.pandit_id IS NOT NULL)
EXECUTE FUNCTION update_pandit_rating();

-- Update temple rating (FIX #5 - uses typed temple_id column)
CREATE OR REPLACE FUNCTION update_temple_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE temples SET
    rating        = (SELECT AVG(rating) FROM reviews WHERE temple_id = NEW.temple_id),
    total_reviews = (SELECT COUNT(*)    FROM reviews WHERE temple_id = NEW.temple_id)
  WHERE id = NEW.temple_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_temple_rating
AFTER INSERT OR UPDATE ON reviews
FOR EACH ROW WHEN (NEW.temple_id IS NOT NULL)
EXECUTE FUNCTION update_temple_rating();

-- Update slot booked_count
CREATE OR REPLACE FUNCTION update_slot_count()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.slot_id IS NOT NULL THEN
    UPDATE temple_slots
    SET booked_count = booked_count + 1,
        is_available  = (booked_count + 1 < capacity)
    WHERE id = NEW.slot_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_slot_count
AFTER INSERT ON bookings
FOR EACH ROW WHEN (NEW.status = 'confirmed')
EXECUTE FUNCTION update_slot_count();

-- Credit pandit wallet on booking completion
CREATE OR REPLACE FUNCTION credit_pandit_wallet()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'completed' AND OLD.status != 'completed' AND NEW.pandit_id IS NOT NULL THEN
    UPDATE wallets
    SET balance        = balance + NEW.pandit_amount,
        total_earned   = total_earned + NEW.pandit_amount,
        updated_at     = NOW()
    WHERE pandit_id = NEW.pandit_id;

    INSERT INTO wallet_transactions (wallet_id, booking_id, type, amount, note)
    SELECT id, NEW.id, 'credit', NEW.pandit_amount, 'Booking completed payout'
    FROM wallets WHERE pandit_id = NEW.pandit_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_credit_pandit_wallet
AFTER UPDATE ON bookings
FOR EACH ROW EXECUTE FUNCTION credit_pandit_wallet();
