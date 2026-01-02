-- Categories
INSERT INTO categories (name, color) VALUES
    ('political',      '#1E3A8A'),
    ('military',       '#374151'),
    ('economic',       '#15803D'),
    ('social',         '#7C3AED'),
    ('environmental',  '#16A34A'),
    ('scientific',     '#0EA5E9'),
    ('technological',  '#2563EB'),
    ('health',         '#DC2626'),
    ('cultural',       '#F59E0B'),
    ('sporting',       '#22C55E'),
    ('catastrophic',   '#7F1D1D'),
    ('judicial',       '#4B5563'),
    ('security',       '#991B1B')
ON CONFLICT (name) DO NOTHING;

-- Tags
INSERT INTO tags (name, tag_type) VALUES
    ('Roman Empire', 'empire'),
    ('Byzantine Empire', 'empire'),
    ('Ottoman Empire', 'empire'),
    ('British Empire', 'empire'),
    ('Mongol Empire', 'empire'),
    ('Holy Roman Empire', 'empire'),
    ('Spanish Empire', 'empire'),
    ('French Empire', 'empire'),
    ('Industrial Revolution', 'movement'),
    ('Renaissance', 'movement'),
    ('Enlightenment', 'movement'),
    ('Reformation', 'movement'),
    ('French Revolution', 'movement'),
    ('Scientific Revolution', 'movement'),
    ('Abolitionism', 'movement'),
    ('Nationalism', 'movement'),
    ('Julius Caesar', 'person'),
    ('Augustus', 'person'),
    ('Charlemagne', 'person'),
    ('Napoleon Bonaparte', 'person'),
    ('Queen Victoria', 'person'),
    ('George Washington', 'person'),
    ('Abraham Lincoln', 'person'),
    ('Genghis Khan', 'person'),
    ('Imperialism', 'theme'),
    ('Colonialism', 'theme'),
    ('Trade', 'theme'),
    ('Religion', 'theme'),
    ('Warfare', 'theme'),
    ('Diplomacy', 'theme'),
    ('Technology', 'theme'),
    ('Revolution', 'theme'),
    ('Cold War', 'other'),
    ('World War I', 'other'),
    ('World War II', 'other'),
    ('Great Depression', 'other')
ON CONFLICT (name) DO NOTHING;

-- Regions
INSERT INTO regions (id, name, parent_id) VALUES
    -- Cosmic
    ('10000000-0000-0000-0000-000000000001', 'Universe', NULL),
    ('10000000-0000-0000-0000-000000000002', 'Earth', '10000000-0000-0000-0000-000000000001'),

    -- Continents
    ('20000000-0000-0000-0000-000000000001', 'Africa',        '10000000-0000-0000-0000-000000000002'),
    ('20000000-0000-0000-0000-000000000002', 'Asia',          '10000000-0000-0000-0000-000000000002'),
    ('20000000-0000-0000-0000-000000000003', 'Europe',        '10000000-0000-0000-0000-000000000002'),
    ('20000000-0000-0000-0000-000000000004', 'North America', '10000000-0000-0000-0000-000000000002'),
    ('20000000-0000-0000-0000-000000000005', 'South America', '10000000-0000-0000-0000-000000000002'),
    ('20000000-0000-0000-0000-000000000006', 'Oceania',       '10000000-0000-0000-0000-000000000002'),
    ('20000000-0000-0000-0000-000000000007', 'Antarctica',    '10000000-0000-0000-0000-000000000002'),

    -- Africa sub-regions
    ('30000000-0000-0000-0000-000000000001', 'North Africa',    '20000000-0000-0000-0000-000000000001'),
    ('30000000-0000-0000-0000-000000000002', 'West Africa',     '20000000-0000-0000-0000-000000000001'),
    ('30000000-0000-0000-0000-000000000003', 'East Africa',     '20000000-0000-0000-0000-000000000001'),
    ('30000000-0000-0000-0000-000000000004', 'Central Africa',  '20000000-0000-0000-0000-000000000001'),
    ('30000000-0000-0000-0000-000000000005', 'Southern Africa', '20000000-0000-0000-0000-000000000001'),

    -- Asia sub-regions
    ('30000000-0000-0000-0000-000000000006', 'East Asia',     '20000000-0000-0000-0000-000000000002'),
    ('30000000-0000-0000-0000-000000000007', 'South Asia',    '20000000-0000-0000-0000-000000000002'),
    ('30000000-0000-0000-0000-000000000008', 'Southeast Asia','20000000-0000-0000-0000-000000000002'),
    ('30000000-0000-0000-0000-000000000009', 'Central Asia',  '20000000-0000-0000-0000-000000000002'),
    ('30000000-0000-0000-0000-000000000010', 'Middle East',   '20000000-0000-0000-0000-000000000002'),

    -- Europe sub-regions
    ('30000000-0000-0000-0000-000000000011', 'Western Europe',  '20000000-0000-0000-0000-000000000003'),
    ('30000000-0000-0000-0000-000000000012', 'Eastern Europe',  '20000000-0000-0000-0000-000000000003'),
    ('30000000-0000-0000-0000-000000000013', 'Northern Europe', '20000000-0000-0000-0000-000000000003'),
    ('30000000-0000-0000-0000-000000000014', 'Southern Europe', '20000000-0000-0000-0000-000000000003'),

    -- Americas sub-regions
    ('30000000-0000-0000-0000-000000000015', 'Caribbean',        '20000000-0000-0000-0000-000000000004'),
    ('30000000-0000-0000-0000-000000000016', 'Central America',  '20000000-0000-0000-0000-000000000004'),
    ('30000000-0000-0000-0000-000000000017', 'Northern America', '20000000-0000-0000-0000-000000000004'),

    ('30000000-0000-0000-0000-000000000018', 'Andean Region', '20000000-0000-0000-0000-000000000005'),
    ('30000000-0000-0000-0000-000000000019', 'Southern Cone', '20000000-0000-0000-0000-000000000005'),
    ('30000000-0000-0000-0000-000000000020', 'Amazon Basin',  '20000000-0000-0000-0000-000000000005'),

    -- Oceania sub-regions
    ('30000000-0000-0000-0000-000000000021', 'Australia',  '20000000-0000-0000-0000-000000000006'),
    ('30000000-0000-0000-0000-000000000022', 'Melanesia',  '20000000-0000-0000-0000-000000000006'),
    ('30000000-0000-0000-0000-000000000023', 'Micronesia', '20000000-0000-0000-0000-000000000006'),
    ('30000000-0000-0000-0000-000000000024', 'Polynesia',  '20000000-0000-0000-0000-000000000006')
ON CONFLICT (id) DO NOTHING;