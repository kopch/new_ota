-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types
CREATE TYPE subscription_tier AS ENUM ('free', 'basic', 'pro', 'business');
CREATE TYPE subscription_status AS ENUM ('active', 'canceled', 'past_due');
CREATE TYPE project_status AS ENUM ('processing', 'completed', 'failed');
CREATE TYPE platform_type AS ENUM ('airbnb', 'vrbo', 'booking', 'expedia');

-- Users table (extends auth.users)
CREATE TABLE public.users (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT NOT NULL,
    display_name TEXT,
    tokens_remaining INTEGER DEFAULT 5,
    subscription_tier subscription_tier DEFAULT 'free',
    subscription_status subscription_status,
    stripe_customer_id TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Projects table
CREATE TABLE public.projects (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    name TEXT NOT NULL,
    platform platform_type NOT NULL,
    status project_status DEFAULT 'processing',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Listings table
CREATE TABLE public.listings (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE NOT NULL,
    url TEXT NOT NULL,
    title TEXT,
    description TEXT,
    price DECIMAL(10,2),
    rating DECIMAL(3,2),
    review_count INTEGER,
    image_urls TEXT[],
    amenities TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Audit reports table
CREATE TABLE public.audit_reports (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    listing_id UUID REFERENCES public.listings(id) ON DELETE CASCADE NOT NULL,
    overall_score INTEGER CHECK (overall_score >= 0 AND overall_score <= 100),
    content_score INTEGER CHECK (content_score >= 0 AND content_score <= 100),
    visual_score INTEGER CHECK (visual_score >= 0 AND visual_score <= 100),
    pricing_score INTEGER CHECK (pricing_score >= 0 AND pricing_score <= 100),
    marketing_score INTEGER CHECK (marketing_score >= 0 AND marketing_score <= 100),
    strengths TEXT[],
    weaknesses TEXT[],
    recommendations TEXT[],
    screenshots TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Shared reports table (for public sharing)
CREATE TABLE public.shared_reports (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE NOT NULL,
    share_token TEXT UNIQUE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_projects_user_id ON public.projects(user_id);
CREATE INDEX idx_projects_status ON public.projects(status);
CREATE INDEX idx_listings_project_id ON public.listings(project_id);
CREATE INDEX idx_audit_reports_listing_id ON public.audit_reports(listing_id);
CREATE INDEX idx_shared_reports_token ON public.shared_reports(share_token);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at triggers
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON public.projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security (RLS) policies
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shared_reports ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view own profile" ON public.users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.users
    FOR UPDATE USING (auth.uid() = id);

-- Projects policies
CREATE POLICY "Users can view own projects" ON public.projects
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own projects" ON public.projects
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own projects" ON public.projects
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own projects" ON public.projects
    FOR DELETE USING (auth.uid() = user_id);

-- Listings policies
CREATE POLICY "Users can view listings from own projects" ON public.listings
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.projects 
            WHERE projects.id = listings.project_id 
            AND projects.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can insert listings to own projects" ON public.listings
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.projects 
            WHERE projects.id = listings.project_id 
            AND projects.user_id = auth.uid()
        )
    );

-- Audit reports policies
CREATE POLICY "Users can view reports from own projects" ON public.audit_reports
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.listings 
            JOIN public.projects ON projects.id = listings.project_id
            WHERE listings.id = audit_reports.listing_id 
            AND projects.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can insert reports to own projects" ON public.audit_reports
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.listings 
            JOIN public.projects ON projects.id = listings.project_id
            WHERE listings.id = audit_reports.listing_id 
            AND projects.user_id = auth.uid()
        )
    );

-- Shared reports policies (public read access with token)
CREATE POLICY "Anyone can view shared reports with valid token" ON public.shared_reports
    FOR SELECT USING (share_token IS NOT NULL);

CREATE POLICY "Users can create shared reports for own projects" ON public.shared_reports
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.projects 
            WHERE projects.id = shared_reports.project_id 
            AND projects.user_id = auth.uid()
        )
    );

-- Function to handle new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, email)
    VALUES (NEW.id, NEW.email);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create user profile on signup
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
