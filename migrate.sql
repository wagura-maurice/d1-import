-- migrate.sql - Full KG-ERP Schema for Cloudflare D1
-- Drop all tables in reverse order of dependencies
DROP TABLE IF EXISTS farmer_wallets;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS produce;
DROP TABLE IF EXISTS farmers;
DROP TABLE IF EXISTS factories;
DROP TABLE IF EXISTS counties;

-- Create tables with D1-compatible syntax
CREATE TABLE counties (
  id INTEGER PRIMARY KEY AUTOINCREMENT
);

CREATE TABLE factories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  factory_code TEXT UNIQUE NOT NULL,
  name TEXT,
  base_url TEXT,
  api_user TEXT,
  county_id INTEGER NOT NULL,
  api_user_credentials TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (county_id) REFERENCES counties(id)
);

CREATE TABLE farmers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  factory_id INTEGER NOT NULL,
  farmer_code TEXT UNIQUE NOT NULL,
  can_borrow INTEGER DEFAULT 0,
  centre_code TEXT,
  centre_name TEXT,
  id_number TEXT,
  name TEXT,
  phone TEXT,
  route_code TEXT,
  route_name TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (factory_id) REFERENCES factories(id)
);

CREATE TABLE produce (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  farmer_id INTEGER NOT NULL,
  factory_id INTEGER NOT NULL,
  transaction_id TEXT,
  trans_time TEXT,
  trans_code TEXT,
  route_code TEXT,
  route_name TEXT,
  centre_code TEXT,
  centre_name TEXT,
  net_units REAL,
  payment_rate REAL,
  gross_pay REAL,
  transport_cost REAL,
  transport_recovery REAL,
  other_charges REAL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (farmer_id) REFERENCES farmers(id),
  FOREIGN KEY (factory_id) REFERENCES factories(id)
);

CREATE TABLE transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  farmer_id INTEGER NOT NULL,
  factory_id INTEGER NOT NULL,
  transaction_code TEXT,
  amount REAL,
  charge REAL,
  convenience_fee REAL,
  interest REAL,
  total_amount REAL,
  status TEXT,
  description TEXT,
  system TEXT,
  loan_date TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (farmer_id) REFERENCES farmers(id),
  FOREIGN KEY (factory_id) REFERENCES factories(id)
);

CREATE TABLE farmer_wallets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  farmer_id INTEGER NOT NULL,
  factory_id INTEGER NOT NULL,
  balance REAL DEFAULT 0,
  loan_limit REAL DEFAULT 0,
  borrowed_amount REAL DEFAULT 0,
  available_earnings REAL DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (farmer_id) REFERENCES farmers(id),
  FOREIGN KEY (factory_id) REFERENCES factories(id)
);

-- Insert sample data

-- Counties (10 records)
INSERT INTO counties (id) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

-- Factories (10 records)
INSERT INTO factories (factory_code, name, base_url, api_user, county_id, api_user_credentials, created_at, updated_at) VALUES
('F001', 'Nzoia Dairy Factory', 'https://nzoia.dairy.co.ke', 'api_nzoia', 1, 'nzoia_cred_2024', '2024-01-15 08:00:00', '2024-01-15 08:00:00'),
('F002', 'Kitale Milk Processors', 'https://kitale.dairy.co.ke', 'api_kitale', 1, 'kitale_cred_2024', '2024-01-20 09:00:00', '2024-01-20 09:00:00'),
('F003', 'Eldoret Dairy Ltd', 'https://eldoret.dairy.co.ke', 'api_eldoret', 2, 'eldoret_cred_2024', '2024-02-01 10:00:00', '2024-02-01 10:00:00'),
('F004', 'Molo Milk Factory', 'https://molo.dairy.co.ke', 'api_molo', 3, 'molo_cred_2024', '2024-02-10 11:00:00', '2024-02-10 11:00:00'),
('F005', 'Nyahururu Processors', 'https://nyahururu.dairy.co.ke', 'api_nyahururu', 4, 'nyahururu_cred_2024', '2024-02-15 12:00:00', '2024-02-15 12:00:00'),
('F006', 'Nakuru Dairy Co-op', 'https://nakuru.dairy.co.ke', 'api_nakuru', 3, 'nakuru_cred_2024', '2024-03-01 08:30:00', '2024-03-01 08:30:00'),
('F007', 'Kericho Milk Ltd', 'https://kericho.dairy.co.ke', 'api_kericho', 5, 'kericho_cred_2024', '2024-03-10 09:30:00', '2024-03-10 09:30:00'),
('F008', 'Bomet Dairy Factory', 'https://bomet.dairy.co.ke', 'api_bomet', 6, 'bomet_cred_2024', '2024-03-20 10:30:00', '2024-03-20 10:30:00'),
('F009', 'Kiambu Milk Processors', 'https://kiambu.dairy.co.ke', 'api_kiambu', 7, 'kiambu_cred_2024', '2024-04-01 11:30:00', '2024-04-01 11:30:00'),
('F010', 'Murang''a Dairy Ltd', 'https://muranga.dairy.co.ke', 'api_muranga', 8, 'muranga_cred_2024', '2024-04-10 12:30:00', '2024-04-10 12:30:00');

-- Farmers (10 records)
INSERT INTO farmers (factory_id, farmer_code, can_borrow, centre_code, centre_name, id_number, name, phone, route_code, route_name, created_at, updated_at) VALUES
(1, 'FM001', 1, 'C001', 'Nzoia Centre', '12345678', 'John Kamau', '254712345678', 'R001', 'Route A', '2024-01-15 08:00:00', '2024-01-15 08:00:00'),
(1, 'FM002', 1, 'C001', 'Nzoia Centre', '23456789', 'Mary Wanjiru', '254723456789', 'R001', 'Route A', '2024-01-16 09:00:00', '2024-01-16 09:00:00'),
(2, 'FM003', 1, 'C002', 'Kitale Central', '34567890', 'Peter Kipchoge', '254734567890', 'R002', 'Route B', '2024-01-20 10:00:00', '2024-01-20 10:00:00'),
(2, 'FM004', 0, 'C002', 'Kitale Central', '45678901', 'Jane Achieng', '254745678901', 'R002', 'Route B', '2024-01-21 11:00:00', '2024-01-21 11:00:00'),
(3, 'FM005', 1, 'C003', 'Eldoret East', '56789012', 'David Mwangi', '254756789012', 'R003', 'Route C', '2024-02-01 12:00:00', '2024-02-01 12:00:00'),
(4, 'FM006', 1, 'C004', 'Molo West', '67890123', 'Grace Njeri', '254767890123', 'R004', 'Route D', '2024-02-10 08:30:00', '2024-02-10 08:30:00'),
(5, 'FM007', 0, 'C005', 'Nyahururu North', '78901234', 'Samuel Omondi', '254778901234', 'R005', 'Route E', '2024-02-15 09:30:00', '2024-02-15 09:30:00'),
(6, 'FM008', 1, 'C006', 'Nakuru South', '89012345', 'Lucy Wambui', '254789012345', 'R006', 'Route F', '2024-03-01 10:30:00', '2024-03-01 10:30:00'),
(7, 'FM009', 1, 'C007', 'Kericho Highland', '90123456', 'James Kiprotich', '254790123456', 'R007', 'Route G', '2024-03-10 11:30:00', '2024-03-10 11:30:00'),
(8, 'FM010', 1, 'C008', 'Bomet Center', '01234567', 'Nancy Chepkemoi', '254701234567', 'R008', 'Route H', '2024-03-20 12:30:00', '2024-03-20 12:30:00');

-- Produce (10 records)
INSERT INTO produce (farmer_id, factory_id, transaction_id, trans_time, trans_code, route_code, route_name, centre_code, centre_name, net_units, payment_rate, gross_pay, transport_cost, transport_recovery, other_charges, created_at, updated_at) VALUES
(1, 1, 'TXN001', '2025-11-01 06:30:00', 'PRD001', 'R001', 'Route A', 'C001', 'Nzoia Centre', 120.5, 45.0, 5422.5, 150.0, 50.0, 25.0, '2025-11-01 06:30:00', '2025-11-01 06:30:00'),
(2, 1, 'TXN002', '2025-11-02 07:00:00', 'PRD002', 'R001', 'Route A', 'C001', 'Nzoia Centre', 95.3, 45.0, 4288.5, 120.0, 40.0, 20.0, '2025-11-02 07:00:00', '2025-11-02 07:00:00'),
(3, 2, 'TXN003', '2025-11-03 06:45:00', 'PRD003', 'R002', 'Route B', 'C002', 'Kitale Central', 150.0, 46.0, 6900.0, 180.0, 60.0, 30.0, '2025-11-03 06:45:00', '2025-11-03 06:45:00'),
(4, 2, 'TXN004', '2025-11-04 07:15:00', 'PRD004', 'R002', 'Route B', 'C002', 'Kitale Central', 80.7, 46.0, 3712.2, 100.0, 35.0, 15.0, '2025-11-04 07:15:00', '2025-11-04 07:15:00'),
(5, 3, 'TXN005', '2025-11-05 06:30:00', 'PRD005', 'R003', 'Route C', 'C003', 'Eldoret East', 200.0, 47.0, 9400.0, 250.0, 80.0, 40.0, '2025-11-05 06:30:00', '2025-11-05 06:30:00'),
(6, 4, 'TXN006', '2025-11-06 07:00:00', 'PRD006', 'R004', 'Route D', 'C004', 'Molo West', 110.5, 44.0, 4862.0, 140.0, 45.0, 22.0, '2025-11-06 07:00:00', '2025-11-06 07:00:00'),
(7, 5, 'TXN007', '2025-11-07 06:45:00', 'PRD007', 'R005', 'Route E', 'C005', 'Nyahururu North', 75.2, 45.5, 3421.6, 95.0, 30.0, 18.0, '2025-11-07 06:45:00', '2025-11-07 06:45:00'),
(8, 6, 'TXN008', '2025-11-08 07:20:00', 'PRD008', 'R006', 'Route F', 'C006', 'Nakuru South', 165.8, 46.5, 7709.7, 200.0, 65.0, 35.0, '2025-11-08 07:20:00', '2025-11-08 07:20:00'),
(9, 7, 'TXN009', '2025-11-09 06:30:00', 'PRD009', 'R007', 'Route G', 'C007', 'Kericho Highland', 135.0, 48.0, 6480.0, 170.0, 55.0, 28.0, '2025-11-09 06:30:00', '2025-11-09 06:30:00'),
(10, 8, 'TXN010', '2025-11-10 07:00:00', 'PRD010', 'R008', 'Route H', 'C008', 'Bomet Center', 145.6, 47.5, 6916.0, 185.0, 60.0, 32.0, '2025-11-10 07:00:00', '2025-11-10 07:00:00');

-- Transactions (10 records)
INSERT INTO transactions (farmer_id, factory_id, transaction_code, amount, charge, convenience_fee, interest, total_amount, status, description, system, loan_date, created_at, updated_at) VALUES
(1, 1, 'LOAN001', 5000.0, 150.0, 50.0, 250.0, 5450.0, 'approved', 'Emergency loan for farm inputs', 'KG-ERP', '2025-11-01 10:00:00', '2025-11-01 10:00:00', '2025-11-01 10:00:00'),
(2, 1, 'LOAN002', 3000.0, 90.0, 30.0, 150.0, 3270.0, 'approved', 'Veterinary services loan', 'KG-ERP', '2025-11-02 11:00:00', '2025-11-02 11:00:00', '2025-11-02 11:00:00'),
(3, 2, 'LOAN003', 7500.0, 225.0, 75.0, 375.0, 8175.0, 'approved', 'Feed purchase loan', 'KG-ERP', '2025-11-03 09:30:00', '2025-11-03 09:30:00', '2025-11-03 09:30:00'),
(5, 3, 'LOAN004', 10000.0, 300.0, 100.0, 500.0, 10900.0, 'approved', 'Equipment upgrade loan', 'KG-ERP', '2025-11-05 12:00:00', '2025-11-05 12:00:00', '2025-11-05 12:00:00'),
(6, 4, 'LOAN005', 4000.0, 120.0, 40.0, 200.0, 4360.0, 'pending', 'Seeds and fertilizer loan', 'KG-ERP', '2025-11-06 10:30:00', '2025-11-06 10:30:00', '2025-11-06 10:30:00'),
(8, 6, 'LOAN006', 6000.0, 180.0, 60.0, 300.0, 6540.0, 'approved', 'Irrigation system loan', 'KG-ERP', '2025-11-08 11:30:00', '2025-11-08 11:30:00', '2025-11-08 11:30:00'),
(9, 7, 'LOAN007', 8000.0, 240.0, 80.0, 400.0, 8720.0, 'approved', 'Barn construction loan', 'KG-ERP', '2025-11-09 09:00:00', '2025-11-09 09:00:00', '2025-11-09 09:00:00'),
(10, 8, 'LOAN008', 5500.0, 165.0, 55.0, 275.0, 5995.0, 'approved', 'Dairy equipment loan', 'KG-ERP', '2025-11-10 10:00:00', '2025-11-10 10:00:00', '2025-11-10 10:00:00'),
(1, 1, 'LOAN009', 2500.0, 75.0, 25.0, 125.0, 2725.0, 'rejected', 'Additional loan request', 'KG-ERP', '2025-11-11 11:00:00', '2025-11-11 11:00:00', '2025-11-11 11:00:00'),
(3, 2, 'LOAN010', 4500.0, 135.0, 45.0, 225.0, 4905.0, 'repaid', 'Short-term operational loan', 'KG-ERP', '2025-10-15 10:00:00', '2025-10-15 10:00:00', '2025-11-12 10:00:00');

-- Farmer Wallets (10 records)
INSERT INTO farmer_wallets (farmer_id, factory_id, balance, loan_limit, borrowed_amount, available_earnings, created_at, updated_at) VALUES
(1, 1, 5422.5, 15000.0, 5450.0, 0.0, '2025-11-01 10:00:00', '2025-11-01 10:00:00'),
(2, 1, 4288.5, 12000.0, 3270.0, 1018.5, '2025-11-02 11:00:00', '2025-11-02 11:00:00'),
(3, 2, 6900.0, 20000.0, 0.0, 6900.0, '2025-11-03 09:30:00', '2025-11-12 09:30:00'),
(4, 2, 3712.2, 10000.0, 0.0, 3712.2, '2025-11-04 07:15:00', '2025-11-04 07:15:00'),
(5, 3, 9400.0, 25000.0, 10900.0, 0.0, '2025-11-05 12:00:00', '2025-11-05 12:00:00'),
(6, 4, 4862.0, 18000.0, 4360.0, 502.0, '2025-11-06 10:30:00', '2025-11-06 10:30:00'),
(7, 5, 3421.6, 8000.0, 0.0, 3421.6, '2025-11-07 06:45:00', '2025-11-07 06:45:00'),
(8, 6, 7709.7, 22000.0, 6540.0, 1169.7, '2025-11-08 11:30:00', '2025-11-08 11:30:00'),
(9, 7, 6480.0, 24000.0, 8720.0, 0.0, '2025-11-09 09:00:00', '2025-11-09 09:00:00'),
(10, 8, 6916.0, 20000.0, 5995.0, 921.0, '2025-11-10 10:00:00', '2025-11-10 10:00:00');