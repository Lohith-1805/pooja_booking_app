-- ============================================
-- POOJA PLATFORM - SUPABASE SQL SCHEMA
-- Run this in your Supabase SQL Editor
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================
-- USERS TABLE
-- ============================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  auth_id UUID UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL DEFAULT '',
  phone TEXT UNIQUE NOT NULL,
  email TEXT,
  role TEXT NOT NULL DEFAULT 'devotee' CHECK (role IN ('devotee', 'pandit', 'temple_admin', 'super_admin')),
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
-- PANDITS TABLE
-- ============================
CREATE TABLE IF NOT EXISTS pandits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  bio TEXT,
  experience_years INTEGER DEFAULT 0,
  languages TEXT[] DEFAULT '{}',
  specializations TEXT[] DEFAULT '{}',
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
-- TEMPLES TABLE
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
  opening_time TEXT DEFAULT '06:00 AM',
  closing_time TEXT DEFAULT '08:00 PM',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- POOJAS TABLE
-- ============================
CREATE TABLE IF NOT EXISTS poojas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  temple_id UUID REFERENCES temples(id) ON DELETE CASCADE,
  name_en TEXT NOT NULL,
  name_te TEXT,
  name_hi TEXT,
  duration_mins INTEGER DEFAULT 60,
  base_price INTEGER NOT NULL,
  description TEXT,
  image_url TEXT,
  category TEXT DEFAULT 'both' CHECK (category IN ('temple', 'home', 'both')),
  requirements TEXT[] DEFAULT '{}',
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- TEMPLE SLOTS TABLE
-- ============================
CREATE TABLE IF NOT EXISTS temple_slots (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  temple_id UUID NOT NULL REFERENCES temples(id) ON DELETE CASCADE,
  pooja_id UUID NOT NULL REFERENCES poojas(id) ON DELETE CASCADE,
  slot_date DATE NOT NULL,
  start_time TEXT NOT NULL,
  end_time TEXT NOT NULL,
  capacity INTEGER DEFAULT 1,
  booked_count INTEGER DEFAULT 0,
  price INTEGER NOT NULL,
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- PANDIT AVAILABILITY TABLE
-- ============================
CREATE TABLE IF NOT EXISTS pandit_availability (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pandit_id UUID NOT NULL REFERENCES pandits(id) ON DELETE CASCADE,
  avail_date DATE NOT NULL,
  start_time TEXT NOT NULL,
  end_time TEXT NOT NULL,
  is_booked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(pandit_id, avail_date, start_time)
);

-- ============================
-- BOOKINGS TABLE
-- ============================
CREATE TABLE IF NOT EXISTS bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  devotee_id UUID NOT NULL REFERENCES users(id),
  pandit_id UUID REFERENCES pandits(id),
  temple_id UUID REFERENCES temples(id),
  pooja_id UUID NOT NULL REFERENCES poojas(id),
  slot_id UUID REFERENCES temple_slots(id),
  booking_type TEXT NOT NULL CHECK (booking_type IN ('temple', 'home')),
  booking_date DATE NOT NULL,
  start_time TEXT NOT NULL,
  end_time TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled', 'rejected')),
  gotram TEXT,
  nakshatram TEXT,
  address TEXT,
  total_amount INTEGER NOT NULL,
  platform_fee INTEGER DEFAULT 0,
  pandit_amount INTEGER DEFAULT 0,
  special_instructions TEXT,
  cancellation_reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- PAYMENTS TABLE
-- ============================
CREATE TABLE IF NOT EXISTS payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id UUID NOT NULL REFERENCES bookings(id),
  razorpay_order_id TEXT,
  razorpay_payment_id TEXT,
  razorpay_signature TEXT,
  amount INTEGER NOT NULL,
  currency TEXT DEFAULT 'INR',
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'success', 'failed', 'refunded')),
  refund_amount INTEGER,
  refund_reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- REVIEWS TABLE
-- ============================
CREATE TABLE IF NOT EXISTS reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id UUID NOT NULL REFERENCES bookings(id) UNIQUE,
  reviewer_id UUID NOT NULL REFERENCES users(id),
  reviewee_id TEXT NOT NULL, -- pandit id or temple id
  reviewee_type TEXT NOT NULL CHECK (reviewee_type IN ('pandit', 'temple')),
  rating DOUBLE PRECISION NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  is_visible BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- NOTIFICATIONS TABLE
-- ============================
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  type TEXT NOT NULL, -- booking_confirmed, booking_cancelled, payment_success, etc.
  data JSONB DEFAULT '{}',
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================
-- BANNERS TABLE
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
-- INDEXES FOR PERFORMANCE
-- ============================
CREATE INDEX IF NOT EXISTS idx_bookings_devotee ON bookings(devotee_id);
CREATE INDEX IF NOT EXISTS idx_bookings_pandit ON bookings(pandit_id);
CREATE INDEX IF NOT EXISTS idx_bookings_temple ON bookings(temple_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_date ON bookings(booking_date);
CREATE INDEX IF NOT EXISTS idx_pandits_city ON pandits(city);
CREATE INDEX IF NOT EXISTS idx_pandits_verified ON pandits(is_verified);
CREATE INDEX IF NOT EXISTS idx_temples_city ON temples(city);
CREATE INDEX IF NOT EXISTS idx_temple_slots_date ON temple_slots(slot_date);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id, is_read);

-- ============================
-- ROW LEVEL SECURITY
-- ============================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE pandits ENABLE ROW LEVEL SECURITY;
ALTER TABLE temples ENABLE ROW LEVEL SECURITY;
ALTER TABLE poojas ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE temple_slots ENABLE ROW LEVEL SECURITY;
ALTER TABLE pandit_availability ENABLE ROW LEVEL SECURITY;

-- Users: read own, service role can read all
CREATE POLICY "Users can read own profile" ON users FOR SELECT USING (auth.uid() = auth_id);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE USING (auth.uid() = auth_id);
CREATE POLICY "Service role full access" ON users FOR ALL USING (auth.role() = 'service_role');

-- Pandits: public read (verified), own update
CREATE POLICY "Anyone can read verified pandits" ON pandits FOR SELECT USING (is_verified = TRUE AND is_active = TRUE);
CREATE POLICY "Pandits can update own profile" ON pandits FOR UPDATE USING (
  user_id = (SELECT id FROM users WHERE auth_id = auth.uid())
);
CREATE POLICY "Service role full access pandits" ON pandits FOR ALL USING (auth.role() = 'service_role');

-- Temples: public read (verified)
CREATE POLICY "Anyone can read verified temples" ON temples FOR SELECT USING (is_verified = TRUE AND is_active = TRUE);
CREATE POLICY "Service role full access temples" ON temples FOR ALL USING (auth.role() = 'service_role');

-- Poojas: public read
CREATE POLICY "Anyone can read active poojas" ON poojas FOR SELECT USING (is_active = TRUE);
CREATE POLICY "Service role full access poojas" ON poojas FOR ALL USING (auth.role() = 'service_role');

-- Bookings: user sees own bookings, pandit sees assigned bookings
CREATE POLICY "Devotees see own bookings" ON bookings FOR SELECT USING (
  devotee_id = (SELECT id FROM users WHERE auth_id = auth.uid())
);
CREATE POLICY "Pandits see their bookings" ON bookings FOR SELECT USING (
  pandit_id IN (SELECT id FROM pandits WHERE user_id = (SELECT id FROM users WHERE auth_id = auth.uid()))
);
CREATE POLICY "Devotees can create bookings" ON bookings FOR INSERT WITH CHECK (
  devotee_id = (SELECT id FROM users WHERE auth_id = auth.uid())
);
CREATE POLICY "Service role full access bookings" ON bookings FOR ALL USING (auth.role() = 'service_role');

-- Temple slots: public read
CREATE POLICY "Anyone can read slots" ON temple_slots FOR SELECT USING (TRUE);
CREATE POLICY "Service role full access slots" ON temple_slots FOR ALL USING (auth.role() = 'service_role');

-- Pandit availability: public read
CREATE POLICY "Anyone can read availability" ON pandit_availability FOR SELECT USING (TRUE);
CREATE POLICY "Service role full access availability" ON pandit_availability FOR ALL USING (auth.role() = 'service_role');

-- Notifications: user sees own
CREATE POLICY "Users see own notifications" ON notifications FOR SELECT USING (
  user_id = (SELECT id FROM users WHERE auth_id = auth.uid())
);
CREATE POLICY "Users update own notifications" ON notifications FOR UPDATE USING (
  user_id = (SELECT id FROM users WHERE auth_id = auth.uid())
);

-- ============================
-- SEED DEMO DATA
-- ============================

-- Demo Temples
INSERT INTO temples (id, name, description, address, city, state, location_lat, location_lng, rating, total_reviews, is_verified, opening_time, closing_time) VALUES
('11111111-1111-1111-1111-111111111111', 'Sri Venkateswara Swamy Temple', 'One of the most sacred temples in Hyderabad with daily poojas and homams.', 'Chilkur, Ranga Reddy', 'Hyderabad', 'Telangana', 17.3200, 78.2900, 4.9, 1253, TRUE, '05:30 AM', '09:00 PM'),
('22222222-2222-2222-2222-222222222222', 'Birla Mandir', 'Beautiful white marble temple on hilltop with stunning city views.', 'Naubat Pahad, Khairatabad', 'Hyderabad', 'Telangana', 17.4062, 78.4691, 4.7, 892, TRUE, '07:00 AM', '08:00 PM'),
('33333333-3333-3333-3333-333333333333', 'Keesara Gutta Temple', 'Ancient Shiva temple famous for Shivaratri and daily abhishekams.', 'Keesara, Medchal', 'Hyderabad', 'Telangana', 17.5500, 78.6000, 4.8, 634, TRUE, '06:00 AM', '08:30 PM')
ON CONFLICT (id) DO NOTHING;

-- Demo Poojas
INSERT INTO poojas (id, name_en, name_te, duration_mins, base_price, description, category, requirements) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Satyanarayana Puja', 'సత్యనారాయణ పూజ', 120, 2500, 'Auspicious puja for well-being and prosperity.', 'both', ARRAY['Flowers','Fruits','Milk','Honey']),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Griha Pravesh', 'గృహ ప్రవేశం', 180, 5000, 'Housewarming ceremony for new home blessings.', 'home', ARRAY['Flowers','Kalash','Rice','Coconut']),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Lakshmi Puja', 'లక్ష్మీ పూజ', 90, 1500, 'Goddess Lakshmi puja for wealth and prosperity.', 'both', ARRAY['Red flowers','Lotus','Coins','Sweets']),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'Navagraha Homam', 'నవగ్రహ హోమం', 240, 7500, 'Powerful homam to appease nine planetary deities.', 'both', ARRAY['Havan samgri','Ghee','9 grains','Flowers']),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ganesh Puja', 'గణేశ పూజ', 60, 1000, 'Remove obstacles with Lord Ganesha blessings.', 'both', ARRAY['Durva grass','Modak','Red flowers']),
('ffffffff-ffff-ffff-ffff-ffffffffffff', 'Rudrabhishek', 'రుద్రాభిషేకం', 150, 4000, 'Sacred abhishekam to Lord Shiva.', 'both', ARRAY['Milk','Honey','Curd','Ghee','Bilva leaves'])
ON CONFLICT (id) DO NOTHING;

-- Demo Temple Slots (for Venkateswara temple, next 7 days)
INSERT INTO temple_slots (temple_id, pooja_id, slot_date, start_time, end_time, capacity, price, is_available)
SELECT 
  '11111111-1111-1111-1111-111111111111',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  CURRENT_DATE + s,
  '09:00 AM', '11:00 AM', 5, 2500, TRUE
FROM generate_series(1, 7) AS s
ON CONFLICT DO NOTHING;

INSERT INTO temple_slots (temple_id, pooja_id, slot_date, start_time, end_time, capacity, price, is_available)
SELECT 
  '11111111-1111-1111-1111-111111111111',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  CURRENT_DATE + s,
  '02:00 PM', '04:00 PM', 5, 2500, TRUE
FROM generate_series(1, 7) AS s
ON CONFLICT DO NOTHING;

-- Demo Banners
INSERT INTO banners (title, subtitle, is_active, display_order) VALUES
('Book Poojas Online', 'Temple Poojas & Home Poojas', TRUE, 1),
('Festival Special', 'Extra poojas this Diwali', TRUE, 2),
('New Pandits Available', 'Expert pandits in your city', TRUE, 3)
ON CONFLICT DO NOTHING;

-- ============================
-- HELPER FUNCTIONS
-- ============================

-- Function to update pandit rating after review
CREATE OR REPLACE FUNCTION update_pandit_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE pandits SET
    rating = (SELECT AVG(rating) FROM reviews WHERE reviewee_id = NEW.reviewee_id AND reviewee_type = 'pandit'),
    total_reviews = (SELECT COUNT(*) FROM reviews WHERE reviewee_id = NEW.reviewee_id AND reviewee_type = 'pandit')
  WHERE id::TEXT = NEW.reviewee_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_pandit_rating
AFTER INSERT OR UPDATE ON reviews
FOR EACH ROW WHEN (NEW.reviewee_type = 'pandit')
EXECUTE FUNCTION update_pandit_rating();

-- Function to update temple rating after review
CREATE OR REPLACE FUNCTION update_temple_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE temples SET
    rating = (SELECT AVG(rating) FROM reviews WHERE reviewee_id = NEW.reviewee_id AND reviewee_type = 'temple'),
    total_reviews = (SELECT COUNT(*) FROM reviews WHERE reviewee_id = NEW.reviewee_id AND reviewee_type = 'temple')
  WHERE id::TEXT = NEW.reviewee_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_temple_rating
AFTER INSERT OR UPDATE ON reviews
FOR EACH ROW WHEN (NEW.reviewee_type = 'temple')
EXECUTE FUNCTION update_temple_rating();

-- Function to update slot booked count
CREATE OR REPLACE FUNCTION update_slot_count()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.slot_id IS NOT NULL THEN
    UPDATE temple_slots SET booked_count = booked_count + 1
    WHERE id = NEW.slot_id;
    UPDATE temple_slots SET is_available = (booked_count < capacity)
    WHERE id = NEW.slot_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_slot_count
AFTER INSERT ON bookings
FOR EACH ROW WHEN (NEW.status = 'confirmed')
EXECUTE FUNCTION update_slot_count();
