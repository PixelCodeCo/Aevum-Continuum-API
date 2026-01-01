-- Aevum Continuum Database Schema
-- Migration for Supabase (PostgreSQL)

-- ============================================
-- ENUMS
-- ============================================

-- Date precision levels
CREATE TYPE date_precision AS ENUM ('day', 'month', 'year', 'decade', 'century');

-- Geographic scope for zoom filtering
CREATE TYPE event_scope AS ENUM ('global', 'continental', 'regional', 'local');

-- Workflow status for submissions
CREATE TYPE event_status AS ENUM ('draft', 'submitted', 'pending_review', 'approved', 'rejected');

-- Relationship types between events
CREATE TYPE relationship_type AS ENUM ('caused', 'influenced', 'parallel', 'preceded');

-- Tag types for organizing tags
CREATE TYPE tag_type AS ENUM ('empire', 'movement', 'person', 'theme', 'other');


-- ============================================
-- CORE TABLES
-- ============================================

-- Events: the core table, each row is a single historical event
CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,                                    -- short display name
    summary TEXT,                                           -- concise description
    start_year INTEGER NOT NULL,                            -- when event began, negative for BCE
    start_month SMALLINT CHECK (start_month BETWEEN 1 AND 12),  -- month if known
    start_day SMALLINT CHECK (start_day BETWEEN 1 AND 31),      -- day if known
    end_year INTEGER,                                       -- when it ended, null for single-moment
    end_month SMALLINT CHECK (end_month BETWEEN 1 AND 12),  -- end month if known
    end_day SMALLINT CHECK (end_day BETWEEN 1 AND 31),      -- end day if known
    date_precision date_precision NOT NULL,                 -- confidence level in dates
    scope event_scope NOT NULL,                             -- geographic reach, primary zoom filter
    importance SMALLINT CHECK (importance BETWEEN 1 AND 10), -- optional tiebreaker within scope
    status event_status NOT NULL DEFAULT 'draft',           -- workflow state
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Regions: geographic/cultural areas with hierarchy support
CREATE TABLE regions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,                                     -- display name
    parent_id UUID REFERENCES regions(id) ON DELETE SET NULL, -- parent for hierarchy, null = top-level
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Categories: event classification types for filtering
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,                                     -- e.g. "War", "Cultural"
    color TEXT,                                             -- hex code for UI
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Tags: flexible labeling for empires, movements, figures, themes
CREATE TABLE tags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,                                     -- e.g. "Roman Empire", "Napoleon"
    tag_type tag_type NOT NULL DEFAULT 'other',             -- helps organize tags in UI
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- ============================================
-- JUNCTION TABLES
-- ============================================

-- Event-Regions: many-to-many, events can span multiple regions
CREATE TABLE event_regions (
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    region_id UUID NOT NULL REFERENCES regions(id) ON DELETE CASCADE,
    PRIMARY KEY (event_id, region_id)
);

-- Event-Categories: many-to-many, events can have multiple types
CREATE TABLE event_categories (
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (event_id, category_id)
);

-- Event-Tags: many-to-many, events can have multiple tags
CREATE TABLE event_tags (
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    tag_id UUID NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (event_id, tag_id)
);


-- ============================================
-- RELATIONSHIP TABLE
-- ============================================

-- Event Relationships: links between events for causation, influence, parallels
CREATE TABLE event_relationships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,  -- the "from" event
    target_event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,  -- the "to" event
    relationship_type relationship_type NOT NULL,           -- nature of connection
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT no_self_reference CHECK (source_event_id != target_event_id)
);


-- ============================================
-- SUBMISSION WORKFLOW TABLE
-- ============================================

-- Event Submissions: tracks authorship and review workflow
CREATE TABLE event_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    submitted_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,  -- who created it
    reviewed_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,           -- who approved/rejected
    submitted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    reviewed_at TIMESTAMPTZ,
    review_notes TEXT,                                      -- feedback for rejections
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- ============================================
-- SOURCES TABLE (for future use)
-- ============================================

-- Sources: references and citations for event verification
CREATE TABLE sources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    url TEXT,                                               -- link to source material
    citation TEXT,                                          -- formatted citation text
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- ============================================
-- INDEXES
-- ============================================

-- B-tree index for year range queries (zooming)
CREATE INDEX idx_events_year_range ON events (start_year, end_year);

-- Index for scope-based filtering (zoom levels)
CREATE INDEX idx_events_scope ON events (scope);

-- Index for status filtering (approved events for public view)
CREATE INDEX idx_events_status ON events (status);

-- Composite index for zoom + filter queries
CREATE INDEX idx_events_scope_status_year ON events (scope, status, start_year);

-- GIN indexes on junction tables for fast filtering
CREATE INDEX idx_event_regions_event ON event_regions (event_id);
CREATE INDEX idx_event_regions_region ON event_regions (region_id);

CREATE INDEX idx_event_categories_event ON event_categories (event_id);
CREATE INDEX idx_event_categories_category ON event_categories (category_id);

CREATE INDEX idx_event_tags_event ON event_tags (event_id);
CREATE INDEX idx_event_tags_tag ON event_tags (tag_id);

-- Index for relationship queries
CREATE INDEX idx_event_relationships_source ON event_relationships (source_event_id);
CREATE INDEX idx_event_relationships_target ON event_relationships (target_event_id);

-- Index for region hierarchy queries
CREATE INDEX idx_regions_parent ON regions (parent_id);

-- Index for submission workflow queries
CREATE INDEX idx_event_submissions_event ON event_submissions (event_id);
CREATE INDEX idx_event_submissions_submitted_by ON event_submissions (submitted_by);


-- ============================================
-- TRIGGERS
-- ============================================

-- Auto-update updated_at timestamp on events
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER events_updated_at
    BEFORE UPDATE ON events
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();


-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE regions ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_regions ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_relationships ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE sources ENABLE ROW LEVEL SECURITY;

-- Public read access for approved events
CREATE POLICY "Public can view approved events"
    ON events FOR SELECT
    USING (status = 'approved');

-- Authenticated users can create draft events
CREATE POLICY "Authenticated users can create events"
    ON events FOR INSERT
    TO authenticated
    WITH CHECK (status = 'draft');

-- Users can update their own draft events (via submissions table)
CREATE POLICY "Users can update own drafts"
    ON events FOR UPDATE
    TO authenticated
    USING (
        status = 'draft' AND
        EXISTS (
            SELECT 1 FROM event_submissions
            WHERE event_submissions.event_id = events.id
            AND event_submissions.submitted_by = auth.uid()
        )
    );

-- Public read access for lookup tables
CREATE POLICY "Public can view regions"
    ON regions FOR SELECT
    USING (true);

CREATE POLICY "Public can view categories"
    ON categories FOR SELECT
    USING (true);

CREATE POLICY "Public can view tags"
    ON tags FOR SELECT
    USING (true);

-- Public read access for junction tables (filtered by event visibility)
CREATE POLICY "Public can view event_regions for approved events"
    ON event_regions FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM events
            WHERE events.id = event_regions.event_id
            AND events.status = 'approved'
        )
    );

CREATE POLICY "Public can view event_categories for approved events"
    ON event_categories FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM events
            WHERE events.id = event_categories.event_id
            AND events.status = 'approved'
        )
    );

CREATE POLICY "Public can view event_tags for approved events"
    ON event_tags FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM events
            WHERE events.id = event_tags.event_id
            AND events.status = 'approved'
        )
    );

CREATE POLICY "Public can view event_relationships for approved events"
    ON event_relationships FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM events
            WHERE events.id = event_relationships.source_event_id
            AND events.status = 'approved'
        )
        AND EXISTS (
            SELECT 1 FROM events
            WHERE events.id = event_relationships.target_event_id
            AND events.status = 'approved'
        )
    );

-- Users can view their own submissions
CREATE POLICY "Users can view own submissions"
    ON event_submissions FOR SELECT
    TO authenticated
    USING (submitted_by = auth.uid());

-- Users can create submissions for their events
CREATE POLICY "Users can create submissions"
    ON event_submissions FOR INSERT
    TO authenticated
    WITH CHECK (submitted_by = auth.uid());

-- Public can view sources for approved events
CREATE POLICY "Public can view sources for approved events"
    ON sources FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM events
            WHERE events.id = sources.event_id
            AND events.status = 'approved'
        )
    );