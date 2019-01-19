--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.addresses (
    id integer NOT NULL,
    addressable_id integer,
    addressable_type character varying,
    address_1 text,
    address_2 text,
    city text,
    zipcode text,
    state character varying,
    country character varying,
    "default" boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    neighborhood character varying,
    number character varying
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: admin_dashboards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_dashboards (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: admin_dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_dashboards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_dashboards_id_seq OWNED BY public.admin_dashboards.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    authentication_token character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    company_id integer,
    role character varying,
    name character varying,
    api_token character varying
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_users_id_seq OWNED BY public.admin_users.id;


--
-- Name: banners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.banners (
    id integer NOT NULL,
    company_id integer,
    image character varying,
    title character varying,
    url character varying,
    "position" character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: banners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.banners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.banners_id_seq OWNED BY public.banners.id;


--
-- Name: carts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.carts (
    id integer NOT NULL,
    customer_id integer,
    company_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    environment character varying,
    uuid uuid
);


--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.carts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.carts_id_seq OWNED BY public.carts.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    handle character varying,
    domain text,
    theme_id integer
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.companies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: company_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_settings (
    id integer NOT NULL,
    company_id integer,
    settings public.hstore,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: company_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_settings_id_seq OWNED BY public.company_settings.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts (
    id integer NOT NULL,
    phone_1 character varying,
    phone_2 character varying,
    email character varying,
    contactable_id integer,
    contactable_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contacts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contacts_id_seq OWNED BY public.contacts.id;


--
-- Name: custom_fields; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_fields (
    id integer NOT NULL,
    company_id integer,
    related_type character varying,
    name character varying,
    alphanumeric_name character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    field_type character varying,
    options public.hstore
);


--
-- Name: custom_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_fields_id_seq OWNED BY public.custom_fields.id;


--
-- Name: custom_fields_taxonomies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_fields_taxonomies (
    custom_field_id integer,
    taxonomy_id integer
);


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friendly_id_slugs (
    id integer NOT NULL,
    slug character varying NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(50),
    scope character varying,
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.friendly_id_slugs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.friendly_id_slugs_id_seq OWNED BY public.friendly_id_slugs.id;


--
-- Name: inventories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventories (
    id integer NOT NULL,
    company_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: inventories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventories_id_seq OWNED BY public.inventories.id;


--
-- Name: inventory_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_entries (
    id integer NOT NULL,
    inventory_item_id integer,
    admin_user_id integer,
    description text,
    quantity numeric,
    cost_per_unit numeric,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    store_id integer,
    on_sale boolean DEFAULT true,
    point_of_sale boolean,
    website_sale boolean DEFAULT true
);


--
-- Name: inventory_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_entries_id_seq OWNED BY public.inventory_entries.id;


--
-- Name: inventory_item_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_item_images (
    id integer NOT NULL,
    inventory_item_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    image character varying,
    cover boolean DEFAULT false
);


--
-- Name: inventory_item_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_item_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_item_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_item_images_id_seq OWNED BY public.inventory_item_images.id;


--
-- Name: inventory_item_prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_item_prices (
    id integer NOT NULL,
    inventory_item_id integer,
    value numeric(8,2),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    for_installments numeric(8,2)
);


--
-- Name: inventory_item_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_item_prices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_item_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_item_prices_id_seq OWNED BY public.inventory_item_prices.id;


--
-- Name: inventory_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_items (
    id integer NOT NULL,
    company_id integer,
    name character varying,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    inventory_id integer,
    reference character varying,
    admin_user_id integer,
    merchandising text,
    taxonomy_id integer,
    year integer,
    manufacturer_id integer,
    moving_average_cost numeric(8,2),
    slug character varying,
    uuid uuid,
    barcode character varying,
    reference_number character varying,
    custom_fields public.hstore,
    supplier_id integer
);


--
-- Name: inventory_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_items_id_seq OWNED BY public.inventory_items.id;


--
-- Name: manufacturers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manufacturers (
    id integer NOT NULL,
    name character varying,
    company_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    admin_user_id integer
);


--
-- Name: manufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.manufacturers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: manufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.manufacturers_id_seq OWNED BY public.manufacturers.id;


--
-- Name: oauth_access_grants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_access_grants (
    id integer NOT NULL,
    resource_owner_id integer NOT NULL,
    application_id integer NOT NULL,
    token character varying NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    scopes character varying
);


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_access_grants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_access_grants_id_seq OWNED BY public.oauth_access_grants.id;


--
-- Name: oauth_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_access_tokens (
    id integer NOT NULL,
    resource_owner_id integer,
    application_id integer,
    token character varying NOT NULL,
    refresh_token character varying,
    expires_in integer,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    scopes character varying
);


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_access_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_access_tokens_id_seq OWNED BY public.oauth_access_tokens.id;


--
-- Name: oauth_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_applications (
    id integer NOT NULL,
    name character varying NOT NULL,
    uid character varying NOT NULL,
    secret character varying NOT NULL,
    redirect_uri text NOT NULL,
    scopes character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_applications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_applications_id_seq OWNED BY public.oauth_applications.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    inventory_item_id integer,
    price numeric(8,2),
    quantity numeric(8,2),
    inventory_entry_id integer,
    cart_id integer,
    order_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status character varying,
    parent_id integer,
    uuid uuid,
    price_for_installments numeric(8,2)
);


--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: order_shippings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_shippings (
    id integer NOT NULL,
    cart_id integer,
    order_id integer,
    price numeric,
    delivery_days integer,
    delivery_type text,
    service_type text,
    zipcode text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description text,
    package_width integer,
    package_height integer,
    package_length integer,
    package_weight numeric(8,2)
);


--
-- Name: order_shippings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_shippings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_shippings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_shippings_id_seq OWNED BY public.order_shippings.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    cart_id integer,
    customer_id integer,
    store_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    environment character varying,
    uuid uuid,
    payment_type character varying,
    admin_user_id integer,
    total numeric(8,2)
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pages (
    id integer NOT NULL,
    title text,
    body text,
    company_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    admin_user_id integer
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- Name: payment_gateways; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_gateways (
    id integer NOT NULL,
    store_id integer,
    name character varying,
    email character varying,
    token text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: payment_gateways_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payment_gateways_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_gateways_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payment_gateways_id_seq OWNED BY public.payment_gateways.id;


--
-- Name: payment_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_statuses (
    id integer NOT NULL,
    order_id integer,
    status character varying,
    notification_id text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: payment_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payment_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payment_statuses_id_seq OWNED BY public.payment_statuses.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    authentication_token character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    first_name text,
    last_name text,
    social_security_number character varying,
    nationality character varying,
    receive_newsletter boolean,
    mobile_number character varying,
    home_number character varying,
    work_number character varying,
    home_area_number character varying,
    work_area_number character varying,
    mobile_area_number character varying,
    store_id integer,
    enabled boolean DEFAULT true,
    environment character varying,
    has_password boolean DEFAULT true,
    uuid uuid,
    company_id_number character varying
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.people_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.people_id_seq OWNED BY public.people.id;


--
-- Name: people_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people_roles (
    id integer NOT NULL,
    person_id integer,
    role_id integer
);


--
-- Name: people_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.people_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.people_roles_id_seq OWNED BY public.people_roles.id;


--
-- Name: pos_cash_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pos_cash_entries (
    id integer NOT NULL,
    uuid uuid,
    admin_user_id integer,
    company_id integer,
    entry_type character varying,
    amount numeric(8,2),
    previous_balance numeric(8,2),
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: pos_cash_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pos_cash_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pos_cash_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pos_cash_entries_id_seq OWNED BY public.pos_cash_entries.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: shipping_boxes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipping_boxes (
    id integer NOT NULL,
    length numeric(8,2),
    width numeric(8,2),
    height numeric(8,2),
    weight numeric(8,2),
    inventory_item_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: shipping_boxes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shipping_boxes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shipping_boxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shipping_boxes_id_seq OWNED BY public.shipping_boxes.id;


--
-- Name: super_admin_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.super_admin_users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: super_admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.super_admin_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: super_admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.super_admin_users_id_seq OWNED BY public.super_admin_users.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying,
    tagger_id integer,
    tagger_type character varying,
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.taggings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.taggings_id_seq OWNED BY public.taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    name character varying,
    taggings_count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: taxonomies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taxonomies (
    id integer NOT NULL,
    name text,
    parent_id integer,
    store_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying
);


--
-- Name: taxonomies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.taxonomies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taxonomies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.taxonomies_id_seq OWNED BY public.taxonomies.id;


--
-- Name: taxonomy_hierarchies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taxonomy_hierarchies (
    ancestor_id integer NOT NULL,
    descendant_id integer NOT NULL,
    generations integer NOT NULL
);


--
-- Name: themes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.themes (
    id integer NOT NULL,
    name character varying,
    description text,
    path text,
    public boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    company_id integer,
    vertical_taxonomy_menu boolean DEFAULT false
);


--
-- Name: themes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.themes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.themes_id_seq OWNED BY public.themes.id;


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: admin_dashboards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_dashboards ALTER COLUMN id SET DEFAULT nextval('public.admin_dashboards_id_seq'::regclass);


--
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);


--
-- Name: banners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.banners ALTER COLUMN id SET DEFAULT nextval('public.banners_id_seq'::regclass);


--
-- Name: carts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carts ALTER COLUMN id SET DEFAULT nextval('public.carts_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: company_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_settings ALTER COLUMN id SET DEFAULT nextval('public.company_settings_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts ALTER COLUMN id SET DEFAULT nextval('public.contacts_id_seq'::regclass);


--
-- Name: custom_fields id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_fields ALTER COLUMN id SET DEFAULT nextval('public.custom_fields_id_seq'::regclass);


--
-- Name: friendly_id_slugs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('public.friendly_id_slugs_id_seq'::regclass);


--
-- Name: inventories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventories ALTER COLUMN id SET DEFAULT nextval('public.inventories_id_seq'::regclass);


--
-- Name: inventory_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_entries ALTER COLUMN id SET DEFAULT nextval('public.inventory_entries_id_seq'::regclass);


--
-- Name: inventory_item_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_item_images ALTER COLUMN id SET DEFAULT nextval('public.inventory_item_images_id_seq'::regclass);


--
-- Name: inventory_item_prices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_item_prices ALTER COLUMN id SET DEFAULT nextval('public.inventory_item_prices_id_seq'::regclass);


--
-- Name: inventory_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_items ALTER COLUMN id SET DEFAULT nextval('public.inventory_items_id_seq'::regclass);


--
-- Name: manufacturers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers ALTER COLUMN id SET DEFAULT nextval('public.manufacturers_id_seq'::regclass);


--
-- Name: oauth_access_grants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('public.oauth_access_grants_id_seq'::regclass);


--
-- Name: oauth_access_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.oauth_access_tokens_id_seq'::regclass);


--
-- Name: oauth_applications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_applications ALTER COLUMN id SET DEFAULT nextval('public.oauth_applications_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: order_shippings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_shippings ALTER COLUMN id SET DEFAULT nextval('public.order_shippings_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: payment_gateways id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_gateways ALTER COLUMN id SET DEFAULT nextval('public.payment_gateways_id_seq'::regclass);


--
-- Name: payment_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_statuses ALTER COLUMN id SET DEFAULT nextval('public.payment_statuses_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- Name: people_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people_roles ALTER COLUMN id SET DEFAULT nextval('public.people_roles_id_seq'::regclass);


--
-- Name: pos_cash_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_cash_entries ALTER COLUMN id SET DEFAULT nextval('public.pos_cash_entries_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: shipping_boxes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_boxes ALTER COLUMN id SET DEFAULT nextval('public.shipping_boxes_id_seq'::regclass);


--
-- Name: super_admin_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.super_admin_users ALTER COLUMN id SET DEFAULT nextval('public.super_admin_users_id_seq'::regclass);


--
-- Name: taggings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings ALTER COLUMN id SET DEFAULT nextval('public.taggings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: taxonomies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taxonomies ALTER COLUMN id SET DEFAULT nextval('public.taxonomies_id_seq'::regclass);


--
-- Name: themes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.themes ALTER COLUMN id SET DEFAULT nextval('public.themes_id_seq'::regclass);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admin_dashboards admin_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_dashboards
    ADD CONSTRAINT admin_dashboards_pkey PRIMARY KEY (id);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: banners banners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.banners
    ADD CONSTRAINT banners_pkey PRIMARY KEY (id);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: company_settings company_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_settings
    ADD CONSTRAINT company_settings_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: custom_fields custom_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_fields
    ADD CONSTRAINT custom_fields_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: inventories inventories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventories
    ADD CONSTRAINT inventories_pkey PRIMARY KEY (id);


--
-- Name: inventory_entries inventory_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_entries
    ADD CONSTRAINT inventory_entries_pkey PRIMARY KEY (id);


--
-- Name: inventory_item_images inventory_item_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_item_images
    ADD CONSTRAINT inventory_item_images_pkey PRIMARY KEY (id);


--
-- Name: inventory_item_prices inventory_item_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_item_prices
    ADD CONSTRAINT inventory_item_prices_pkey PRIMARY KEY (id);


--
-- Name: inventory_items inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_pkey PRIMARY KEY (id);


--
-- Name: manufacturers manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_grants oauth_access_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_tokens oauth_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: oauth_applications oauth_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: order_shippings order_shippings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_shippings
    ADD CONSTRAINT order_shippings_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: payment_gateways payment_gateways_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_gateways
    ADD CONSTRAINT payment_gateways_pkey PRIMARY KEY (id);


--
-- Name: payment_statuses payment_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_statuses
    ADD CONSTRAINT payment_statuses_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: people_roles people_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people_roles
    ADD CONSTRAINT people_roles_pkey PRIMARY KEY (id);


--
-- Name: pos_cash_entries pos_cash_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_cash_entries
    ADD CONSTRAINT pos_cash_entries_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: shipping_boxes shipping_boxes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_boxes
    ADD CONSTRAINT shipping_boxes_pkey PRIMARY KEY (id);


--
-- Name: super_admin_users super_admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.super_admin_users
    ADD CONSTRAINT super_admin_users_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: taxonomies taxonomies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taxonomies
    ADD CONSTRAINT taxonomies_pkey PRIMARY KEY (id);


--
-- Name: themes themes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.themes
    ADD CONSTRAINT themes_pkey PRIMARY KEY (id);


--
-- Name: company_settings_gist_settings; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX company_settings_gist_settings ON public.company_settings USING gist (settings);


--
-- Name: customer_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customer_email ON public.people USING gin (to_tsvector('english'::regconfig, (email)::text));


--
-- Name: customer_first_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customer_first_name ON public.people USING gin (to_tsvector('english'::regconfig, first_name));


--
-- Name: customer_last_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customer_last_name ON public.people USING gin (to_tsvector('english'::regconfig, first_name));


--
-- Name: customer_social_security_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customer_social_security_number ON public.people USING gin (to_tsvector('english'::regconfig, (social_security_number)::text));


--
-- Name: good_description; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX good_description ON public.inventory_items USING gin (to_tsvector('english'::regconfig, description));


--
-- Name: good_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX good_name ON public.inventory_items USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: index_addresses_on_addressable_id_and_addressable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_addressable_id_and_addressable_type ON public.addresses USING btree (addressable_id, addressable_type);


--
-- Name: index_addresses_on_default; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_default ON public.addresses USING btree ("default");


--
-- Name: index_admin_users_on_api_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admin_users_on_api_token ON public.admin_users USING btree (api_token);


--
-- Name: index_admin_users_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admin_users_on_company_id ON public.admin_users USING btree (company_id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_email ON public.admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON public.admin_users USING btree (reset_password_token);


--
-- Name: index_banners_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_banners_on_company_id ON public.banners USING btree (company_id);


--
-- Name: index_carts_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_carts_on_company_id ON public.carts USING btree (company_id);


--
-- Name: index_carts_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_carts_on_customer_id ON public.carts USING btree (customer_id);


--
-- Name: index_carts_on_environment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_carts_on_environment ON public.carts USING btree (environment);


--
-- Name: index_carts_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_carts_on_uuid ON public.carts USING btree (uuid);


--
-- Name: index_companies_on_domain; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_domain ON public.companies USING btree (domain);


--
-- Name: index_companies_on_handle; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_handle ON public.companies USING btree (handle);


--
-- Name: index_companies_on_theme_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_theme_id ON public.companies USING btree (theme_id);


--
-- Name: index_company_settings_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_settings_on_company_id ON public.company_settings USING btree (company_id);


--
-- Name: index_contacts_on_contactable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_contactable_id ON public.contacts USING btree (contactable_id);


--
-- Name: index_contacts_on_contactable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_contactable_type ON public.contacts USING btree (contactable_type);


--
-- Name: index_custom_fields_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_fields_on_company_id ON public.custom_fields USING btree (company_id);


--
-- Name: index_custom_fields_on_options; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_fields_on_options ON public.custom_fields USING gin (options);


--
-- Name: index_custom_fields_on_related_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_fields_on_related_type ON public.custom_fields USING btree (related_type);


--
-- Name: index_custom_fields_taxonomies_on_custom_field_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_fields_taxonomies_on_custom_field_id ON public.custom_fields_taxonomies USING btree (custom_field_id);


--
-- Name: index_custom_fields_taxonomies_on_taxonomy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_fields_taxonomies_on_taxonomy_id ON public.custom_fields_taxonomies USING btree (taxonomy_id);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON public.friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON public.friendly_id_slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON public.friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON public.friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_inventory_entries_on_admin_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_entries_on_admin_user_id ON public.inventory_entries USING btree (admin_user_id);


--
-- Name: index_inventory_entries_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_entries_on_inventory_item_id ON public.inventory_entries USING btree (inventory_item_id);


--
-- Name: index_inventory_entries_on_on_sale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_entries_on_on_sale ON public.inventory_entries USING btree (on_sale);


--
-- Name: index_inventory_entries_on_point_of_sale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_entries_on_point_of_sale ON public.inventory_entries USING btree (point_of_sale);


--
-- Name: index_inventory_entries_on_store_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_entries_on_store_id ON public.inventory_entries USING btree (store_id);


--
-- Name: index_inventory_item_images_on_cover; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_item_images_on_cover ON public.inventory_item_images USING btree (cover);


--
-- Name: index_inventory_item_images_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_item_images_on_inventory_item_id ON public.inventory_item_images USING btree (inventory_item_id);


--
-- Name: index_inventory_item_prices_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_item_prices_on_inventory_item_id ON public.inventory_item_prices USING btree (inventory_item_id);


--
-- Name: index_inventory_items_on_barcode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_items_on_barcode ON public.inventory_items USING btree (barcode);


--
-- Name: index_inventory_items_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_items_on_company_id ON public.inventory_items USING btree (company_id);


--
-- Name: index_inventory_items_on_custom_fields; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_items_on_custom_fields ON public.inventory_items USING gin (custom_fields);


--
-- Name: index_inventory_items_on_manufacturer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_items_on_manufacturer_id ON public.inventory_items USING btree (manufacturer_id);


--
-- Name: index_inventory_items_on_reference_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_items_on_reference_number ON public.inventory_items USING btree (reference_number);


--
-- Name: index_inventory_items_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_items_on_slug ON public.inventory_items USING btree (slug);


--
-- Name: index_inventory_items_on_supplier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_items_on_supplier_id ON public.inventory_items USING btree (supplier_id);


--
-- Name: index_inventory_items_on_taxonomy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_items_on_taxonomy_id ON public.inventory_items USING btree (taxonomy_id);


--
-- Name: index_inventory_items_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_items_on_uuid ON public.inventory_items USING btree (uuid);


--
-- Name: index_manufacturers_on_admin_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_manufacturers_on_admin_user_id ON public.manufacturers USING btree (admin_user_id);


--
-- Name: index_manufacturers_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_manufacturers_on_company_id ON public.manufacturers USING btree (company_id);


--
-- Name: index_oauth_access_grants_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON public.oauth_access_grants USING btree (token);


--
-- Name: index_oauth_access_tokens_on_refresh_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON public.oauth_access_tokens USING btree (refresh_token);


--
-- Name: index_oauth_access_tokens_on_resource_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON public.oauth_access_tokens USING btree (resource_owner_id);


--
-- Name: index_oauth_access_tokens_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON public.oauth_access_tokens USING btree (token);


--
-- Name: index_oauth_applications_on_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_applications_on_uid ON public.oauth_applications USING btree (uid);


--
-- Name: index_order_items_on_cart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_items_on_cart_id ON public.order_items USING btree (cart_id);


--
-- Name: index_order_items_on_inventory_entry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_items_on_inventory_entry_id ON public.order_items USING btree (inventory_entry_id);


--
-- Name: index_order_items_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_items_on_inventory_item_id ON public.order_items USING btree (inventory_item_id);


--
-- Name: index_order_items_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_items_on_order_id ON public.order_items USING btree (order_id);


--
-- Name: index_order_items_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_items_on_parent_id ON public.order_items USING btree (parent_id);


--
-- Name: index_order_items_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_items_on_status ON public.order_items USING btree (status);


--
-- Name: index_order_items_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_items_on_uuid ON public.order_items USING btree (uuid);


--
-- Name: index_order_shippings_on_cart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_shippings_on_cart_id ON public.order_shippings USING btree (cart_id);


--
-- Name: index_order_shippings_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_shippings_on_order_id ON public.order_shippings USING btree (order_id);


--
-- Name: index_orders_on_admin_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_admin_user_id ON public.orders USING btree (admin_user_id);


--
-- Name: index_orders_on_cart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_cart_id ON public.orders USING btree (cart_id);


--
-- Name: index_orders_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_customer_id ON public.orders USING btree (customer_id);


--
-- Name: index_orders_on_environment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_environment ON public.orders USING btree (environment);


--
-- Name: index_orders_on_store_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_store_id ON public.orders USING btree (store_id);


--
-- Name: index_orders_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_uuid ON public.orders USING btree (uuid);


--
-- Name: index_pages_on_admin_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_on_admin_user_id ON public.pages USING btree (admin_user_id);


--
-- Name: index_pages_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_on_company_id ON public.pages USING btree (company_id);


--
-- Name: index_payment_gateways_on_store_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_gateways_on_store_id ON public.payment_gateways USING btree (store_id);


--
-- Name: index_payment_statuses_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_statuses_on_order_id ON public.payment_statuses USING btree (order_id);


--
-- Name: index_payment_statuses_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_statuses_on_status ON public.payment_statuses USING btree (status);


--
-- Name: index_people_on_authentication_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_authentication_token ON public.people USING btree (authentication_token);


--
-- Name: index_people_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_confirmation_token ON public.people USING btree (confirmation_token);


--
-- Name: index_people_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_email ON public.people USING btree (email);


--
-- Name: index_people_on_enabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_enabled ON public.people USING btree (enabled);


--
-- Name: index_people_on_environment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_environment ON public.people USING btree (environment);


--
-- Name: index_people_on_receive_newsletter; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_receive_newsletter ON public.people USING btree (receive_newsletter);


--
-- Name: index_people_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_reset_password_token ON public.people USING btree (reset_password_token);


--
-- Name: index_people_on_store_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_store_id ON public.people USING btree (store_id);


--
-- Name: index_people_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_uuid ON public.people USING btree (uuid);


--
-- Name: index_people_roles_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_roles_on_person_id ON public.people_roles USING btree (person_id);


--
-- Name: index_people_roles_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_roles_on_role_id ON public.people_roles USING btree (role_id);


--
-- Name: index_pos_cash_entries_on_admin_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pos_cash_entries_on_admin_user_id ON public.pos_cash_entries USING btree (admin_user_id);


--
-- Name: index_pos_cash_entries_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pos_cash_entries_on_company_id ON public.pos_cash_entries USING btree (company_id);


--
-- Name: index_pos_cash_entries_on_entry_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pos_cash_entries_on_entry_type ON public.pos_cash_entries USING btree (entry_type);


--
-- Name: index_pos_cash_entries_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pos_cash_entries_on_uuid ON public.pos_cash_entries USING btree (uuid);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_name ON public.roles USING btree (name);


--
-- Name: index_shipping_boxes_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shipping_boxes_on_inventory_item_id ON public.shipping_boxes USING btree (inventory_item_id);


--
-- Name: index_super_admin_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_super_admin_users_on_email ON public.super_admin_users USING btree (email);


--
-- Name: index_super_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_super_admin_users_on_reset_password_token ON public.super_admin_users USING btree (reset_password_token);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON public.taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- Name: index_taxonomies_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taxonomies_on_parent_id ON public.taxonomies USING btree (parent_id);


--
-- Name: index_taxonomies_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taxonomies_on_slug ON public.taxonomies USING btree (slug);


--
-- Name: index_taxonomies_on_store_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taxonomies_on_store_id ON public.taxonomies USING btree (store_id);


--
-- Name: index_taxonomy_hierarchies_on_ancestor_id_and_descendant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_taxonomy_hierarchies_on_ancestor_id_and_descendant_id ON public.taxonomy_hierarchies USING btree (ancestor_id, descendant_id);


--
-- Name: index_taxonomy_hierarchies_on_descendant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taxonomy_hierarchies_on_descendant_id ON public.taxonomy_hierarchies USING btree (descendant_id);


--
-- Name: index_themes_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_themes_on_company_id ON public.themes USING btree (company_id);


--
-- Name: inventory_item_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_item_name ON public.inventory_items USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: manufacturers_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX manufacturers_name ON public.manufacturers USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX taggings_idx ON public.taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: taxonomies_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taxonomies_name ON public.taxonomies USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20120215233120');

INSERT INTO schema_migrations (version) VALUES ('20120221230738');

INSERT INTO schema_migrations (version) VALUES ('20120221230836');

INSERT INTO schema_migrations (version) VALUES ('20120221235642');

INSERT INTO schema_migrations (version) VALUES ('20120222000653');

INSERT INTO schema_migrations (version) VALUES ('20120222231903');

INSERT INTO schema_migrations (version) VALUES ('20120222233218');

INSERT INTO schema_migrations (version) VALUES ('20120225040749');

INSERT INTO schema_migrations (version) VALUES ('20120229042537');

INSERT INTO schema_migrations (version) VALUES ('20120307023951');

INSERT INTO schema_migrations (version) VALUES ('20120401230014');

INSERT INTO schema_migrations (version) VALUES ('20120414162829');

INSERT INTO schema_migrations (version) VALUES ('20120415012630');

INSERT INTO schema_migrations (version) VALUES ('20120417020928');

INSERT INTO schema_migrations (version) VALUES ('20120422022923');

INSERT INTO schema_migrations (version) VALUES ('20120720225933');

INSERT INTO schema_migrations (version) VALUES ('20120722070927');

INSERT INTO schema_migrations (version) VALUES ('20120723012339');

INSERT INTO schema_migrations (version) VALUES ('20120807013604');

INSERT INTO schema_migrations (version) VALUES ('20120807013854');

INSERT INTO schema_migrations (version) VALUES ('20120829155737');

INSERT INTO schema_migrations (version) VALUES ('20120829161803');

INSERT INTO schema_migrations (version) VALUES ('20120909211724');

INSERT INTO schema_migrations (version) VALUES ('20121018022814');

INSERT INTO schema_migrations (version) VALUES ('20121031011538');

INSERT INTO schema_migrations (version) VALUES ('20121106222802');

INSERT INTO schema_migrations (version) VALUES ('20121106223719');

INSERT INTO schema_migrations (version) VALUES ('20121109074438');

INSERT INTO schema_migrations (version) VALUES ('20121114014017');

INSERT INTO schema_migrations (version) VALUES ('20121117023754');

INSERT INTO schema_migrations (version) VALUES ('20121117024812');

INSERT INTO schema_migrations (version) VALUES ('20121125010831');

INSERT INTO schema_migrations (version) VALUES ('20121216001442');

INSERT INTO schema_migrations (version) VALUES ('20121219003059');

INSERT INTO schema_migrations (version) VALUES ('20121219005832');

INSERT INTO schema_migrations (version) VALUES ('20121220012219');

INSERT INTO schema_migrations (version) VALUES ('20121222193601');

INSERT INTO schema_migrations (version) VALUES ('20121224011412');

INSERT INTO schema_migrations (version) VALUES ('20121224061117');

INSERT INTO schema_migrations (version) VALUES ('20121225191435');

INSERT INTO schema_migrations (version) VALUES ('20121225203245');

INSERT INTO schema_migrations (version) VALUES ('20121227022754');

INSERT INTO schema_migrations (version) VALUES ('20130101030424');

INSERT INTO schema_migrations (version) VALUES ('20130101030632');

INSERT INTO schema_migrations (version) VALUES ('20130116005754');

INSERT INTO schema_migrations (version) VALUES ('20130122004925');

INSERT INTO schema_migrations (version) VALUES ('20130209055558');

INSERT INTO schema_migrations (version) VALUES ('20130209072541');

INSERT INTO schema_migrations (version) VALUES ('20130213041013');

INSERT INTO schema_migrations (version) VALUES ('20130217201429');

INSERT INTO schema_migrations (version) VALUES ('20130217202510');

INSERT INTO schema_migrations (version) VALUES ('20130217202710');

INSERT INTO schema_migrations (version) VALUES ('20130219173554');

INSERT INTO schema_migrations (version) VALUES ('20130220175350');

INSERT INTO schema_migrations (version) VALUES ('20130220181633');

INSERT INTO schema_migrations (version) VALUES ('20130220182904');

INSERT INTO schema_migrations (version) VALUES ('20130220200724');

INSERT INTO schema_migrations (version) VALUES ('20130220200955');

INSERT INTO schema_migrations (version) VALUES ('20130222202202');

INSERT INTO schema_migrations (version) VALUES ('20130303065958');

INSERT INTO schema_migrations (version) VALUES ('20130304002307');

INSERT INTO schema_migrations (version) VALUES ('20130304003040');

INSERT INTO schema_migrations (version) VALUES ('20130309232957');

INSERT INTO schema_migrations (version) VALUES ('20130317211352');

INSERT INTO schema_migrations (version) VALUES ('20130414161633');

INSERT INTO schema_migrations (version) VALUES ('20130601221654');

INSERT INTO schema_migrations (version) VALUES ('20130613001445');

INSERT INTO schema_migrations (version) VALUES ('20130613005952');

INSERT INTO schema_migrations (version) VALUES ('20130616190239');

INSERT INTO schema_migrations (version) VALUES ('20130625133338');

INSERT INTO schema_migrations (version) VALUES ('20130629135556');

INSERT INTO schema_migrations (version) VALUES ('20130630215009');

INSERT INTO schema_migrations (version) VALUES ('20130710222535');

INSERT INTO schema_migrations (version) VALUES ('20131109185749');

INSERT INTO schema_migrations (version) VALUES ('20131109190457');

INSERT INTO schema_migrations (version) VALUES ('20131109191443');

INSERT INTO schema_migrations (version) VALUES ('20131109193957');

INSERT INTO schema_migrations (version) VALUES ('20131109194043');

INSERT INTO schema_migrations (version) VALUES ('20131112020049');

INSERT INTO schema_migrations (version) VALUES ('20131112020339');

INSERT INTO schema_migrations (version) VALUES ('20131112022336');

INSERT INTO schema_migrations (version) VALUES ('20131112193300');

INSERT INTO schema_migrations (version) VALUES ('20131112201449');

INSERT INTO schema_migrations (version) VALUES ('20131230032123');

INSERT INTO schema_migrations (version) VALUES ('20131230034242');

INSERT INTO schema_migrations (version) VALUES ('20131230050607');

INSERT INTO schema_migrations (version) VALUES ('20131230090113');

INSERT INTO schema_migrations (version) VALUES ('20140102130350');

INSERT INTO schema_migrations (version) VALUES ('20140102130528');

INSERT INTO schema_migrations (version) VALUES ('20140127210800');

INSERT INTO schema_migrations (version) VALUES ('20140128043555');

INSERT INTO schema_migrations (version) VALUES ('20140129020437');

INSERT INTO schema_migrations (version) VALUES ('20140130184208');

INSERT INTO schema_migrations (version) VALUES ('20140203204310');

INSERT INTO schema_migrations (version) VALUES ('20140204223539');

INSERT INTO schema_migrations (version) VALUES ('20140205004313');

INSERT INTO schema_migrations (version) VALUES ('20140206183554');

INSERT INTO schema_migrations (version) VALUES ('20140206214943');

INSERT INTO schema_migrations (version) VALUES ('20140212192749');

INSERT INTO schema_migrations (version) VALUES ('20140212192750');

INSERT INTO schema_migrations (version) VALUES ('20140213191047');

INSERT INTO schema_migrations (version) VALUES ('20140213192712');

INSERT INTO schema_migrations (version) VALUES ('20140213224021');

INSERT INTO schema_migrations (version) VALUES ('20140221170717');

INSERT INTO schema_migrations (version) VALUES ('20140221194950');

INSERT INTO schema_migrations (version) VALUES ('20140221195034');

INSERT INTO schema_migrations (version) VALUES ('20140223144047');

INSERT INTO schema_migrations (version) VALUES ('20140225230047');

INSERT INTO schema_migrations (version) VALUES ('20140309233819');

INSERT INTO schema_migrations (version) VALUES ('20140409011830');

INSERT INTO schema_migrations (version) VALUES ('20140521165135');

INSERT INTO schema_migrations (version) VALUES ('20141231223527');

INSERT INTO schema_migrations (version) VALUES ('20150103002904');

INSERT INTO schema_migrations (version) VALUES ('20150103002905');

