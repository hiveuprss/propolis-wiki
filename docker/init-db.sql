-- Schema for local Docker (role/db created by POSTGRES_* env).

CREATE TABLE public.categories (
    category character varying(255) NOT NULL,
    CONSTRAINT categories_pkey PRIMARY KEY (category)
);

CREATE TABLE public.categories_posts (
    permlink character varying(255) NOT NULL,
    category character varying(255) NOT NULL
);

CREATE TABLE public.comments (
    trx_id character varying(160) NOT NULL,
    permlink character varying(255) NOT NULL,
    "timestamp" timestamp without time zone,
    author character varying(16),
    CONSTRAINT comments_pkey PRIMARY KEY (trx_id)
);

CREATE TABLE public.posts (
    permlink character varying(255) NOT NULL,
    tsvector tsvector,
    CONSTRAINT posts_pkey PRIMARY KEY (permlink)
);

CREATE INDEX comments_permlink_timestamp_idx
    ON public.comments (permlink, "timestamp" DESC);

CREATE INDEX categories_posts_category_idx
    ON public.categories_posts (category);

CREATE INDEX categories_posts_permlink_idx
    ON public.categories_posts (permlink);

CREATE INDEX posts_tsvector_idx
    ON public.posts USING gin (tsvector);

-- Bootstrap last_update for the default start page so /wiki renders
-- without a full Hive sync. Real timestamps arrive when updater runs.
INSERT INTO public.comments (trx_id, permlink, timestamp, author)
VALUES ('docker-bootstrap', 'welcome-to-propolis-wiki', NOW(), 'propolis');
