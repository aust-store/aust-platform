--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    addressable_id integer,
    addressable_type character varying(255),
    address_1 text,
    address_2 text,
    city text,
    zipcode text,
    state character varying(255),
    country character varying(255),
    "default" boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    neighborhood character varying(255),
    number character varying(255)
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: admin_dashboards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_dashboards (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: admin_dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_dashboards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_dashboards_id_seq OWNED BY admin_dashboards.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    authentication_token character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    company_id integer,
    role character varying(255),
    name character varying(255)
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: banners; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE banners (
    id integer NOT NULL,
    company_id integer,
    image character varying(255),
    title character varying(255),
    url character varying(255),
    "position" character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: banners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE banners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE banners_id_seq OWNED BY banners.id;


--
-- Name: carts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE carts (
    id integer NOT NULL,
    customer_id integer,
    company_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    environment character varying(255),
    uuid uuid
);


--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE carts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE carts_id_seq OWNED BY carts.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE companies (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    handle character varying(255),
    domain text,
    theme_id integer
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE companies_id_seq OWNED BY companies.id;


--
-- Name: company_settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE company_settings (
    id integer NOT NULL,
    company_id integer,
    settings hstore,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: company_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE company_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE company_settings_id_seq OWNED BY company_settings.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contacts (
    id integer NOT NULL,
    phone_1 character varying(255),
    phone_2 character varying(255),
    email character varying(255),
    contactable_id integer,
    contactable_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;


--
-- Name: custom_fields; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE custom_fields (
    id integer NOT NULL,
    company_id integer,
    related_type character varying(255),
    name character varying(255),
    alphanumeric_name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: custom_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE custom_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE custom_fields_id_seq OWNED BY custom_fields.id;


--
-- Name: custom_fields_taxonomies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE custom_fields_taxonomies (
    custom_field_id integer,
    taxonomy_id integer
);


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE friendly_id_slugs (
    id integer NOT NULL,
    slug character varying(255) NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(50),
    scope character varying(255),
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendly_id_slugs_id_seq OWNED BY friendly_id_slugs.id;


--
-- Name: inventories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE inventories (
    id integer NOT NULL,
    company_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: inventories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE inventories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE inventories_id_seq OWNED BY inventories.id;


--
-- Name: inventory_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE inventory_entries (
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

CREATE SEQUENCE inventory_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE inventory_entries_id_seq OWNED BY inventory_entries.id;


--
-- Name: inventory_item_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE inventory_item_images (
    id integer NOT NULL,
    inventory_item_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    image character varying(255),
    cover boolean DEFAULT false
);


--
-- Name: inventory_item_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE inventory_item_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_item_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE inventory_item_images_id_seq OWNED BY inventory_item_images.id;


--
-- Name: inventory_item_prices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE inventory_item_prices (
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

CREATE SEQUENCE inventory_item_prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_item_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE inventory_item_prices_id_seq OWNED BY inventory_item_prices.id;


--
-- Name: inventory_item_properties; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE inventory_item_properties (
    id integer NOT NULL,
    inventory_item_id integer,
    properties hstore,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: inventory_item_properties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE inventory_item_properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_item_properties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE inventory_item_properties_id_seq OWNED BY inventory_item_properties.id;


--
-- Name: inventory_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE inventory_items (
    id integer NOT NULL,
    company_id integer,
    name character varying(255),
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    inventory_id integer,
    reference character varying(255),
    admin_user_id integer,
    merchandising text,
    taxonomy_id integer,
    year integer,
    manufacturer_id integer,
    moving_average_cost numeric(8,2),
    slug character varying(255),
    uuid uuid,
    barcode character varying(255),
    reference_number character varying(255),
    custom_fields hstore
);


--
-- Name: inventory_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE inventory_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE inventory_items_id_seq OWNED BY inventory_items.id;


--
-- Name: manufacturers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE manufacturers (
    id integer NOT NULL,
    name character varying(255),
    company_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    admin_user_id integer
);


--
-- Name: manufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE manufacturers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: manufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE manufacturers_id_seq OWNED BY manufacturers.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE order_items (
    id integer NOT NULL,
    inventory_item_id integer,
    price numeric(8,2),
    quantity numeric(8,2),
    inventory_entry_id integer,
    cart_id integer,
    order_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status character varying(255),
    parent_id integer,
    uuid uuid,
    price_for_installments numeric(8,2)
);


--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE order_items_id_seq OWNED BY order_items.id;


--
-- Name: order_shippings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE order_shippings (
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

CREATE SEQUENCE order_shippings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_shippings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE order_shippings_id_seq OWNED BY order_shippings.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE orders (
    id integer NOT NULL,
    cart_id integer,
    customer_id integer,
    store_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    environment character varying(255),
    uuid uuid,
    payment_type character varying(255),
    admin_user_id integer,
    total numeric(8,2)
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
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

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: payment_gateways; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE payment_gateways (
    id integer NOT NULL,
    store_id integer,
    name character varying(255),
    email character varying(255),
    token text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: payment_gateways_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payment_gateways_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_gateways_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payment_gateways_id_seq OWNED BY payment_gateways.id;


--
-- Name: payment_statuses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE payment_statuses (
    id integer NOT NULL,
    order_id integer,
    status character varying(255),
    notification_id text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: payment_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payment_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payment_statuses_id_seq OWNED BY payment_statuses.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE people (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    authentication_token character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    first_name text,
    last_name text,
    social_security_number character varying(255),
    nationality character varying(255),
    receive_newsletter boolean,
    mobile_number character varying(255),
    home_number character varying(255),
    work_number character varying(255),
    home_area_number character varying(255),
    work_area_number character varying(255),
    mobile_area_number character varying(255),
    store_id integer,
    enabled boolean DEFAULT true,
    environment character varying(255),
    has_password boolean DEFAULT true,
    uuid uuid,
    company_id_number character varying(255)
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE people_id_seq OWNED BY people.id;


--
-- Name: people_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE people_roles (
    id integer NOT NULL,
    person_id integer,
    role_id integer
);


--
-- Name: people_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE people_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE people_roles_id_seq OWNED BY people_roles.id;


--
-- Name: pos_cash_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pos_cash_entries (
    id integer NOT NULL,
    uuid uuid,
    admin_user_id integer,
    company_id integer,
    entry_type character varying(255),
    amount numeric(8,2),
    previous_balance numeric(8,2),
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: pos_cash_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pos_cash_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pos_cash_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pos_cash_entries_id_seq OWNED BY pos_cash_entries.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: shipping_boxes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shipping_boxes (
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

CREATE SEQUENCE shipping_boxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shipping_boxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shipping_boxes_id_seq OWNED BY shipping_boxes.id;


--
-- Name: super_admin_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE super_admin_users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: super_admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE super_admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: super_admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE super_admin_users_id_seq OWNED BY super_admin_users.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying(255),
    tagger_id integer,
    tagger_type character varying(255),
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: taxonomies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taxonomies (
    id integer NOT NULL,
    name text,
    parent_id integer,
    store_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying(255)
);


--
-- Name: taxonomies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taxonomies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taxonomies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taxonomies_id_seq OWNED BY taxonomies.id;


--
-- Name: taxonomy_hierarchies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taxonomy_hierarchies (
    ancestor_id integer NOT NULL,
    descendant_id integer NOT NULL,
    generations integer NOT NULL
);


--
-- Name: themes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE themes (
    id integer NOT NULL,
    name character varying(255),
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

CREATE SEQUENCE themes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE themes_id_seq OWNED BY themes.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_dashboards ALTER COLUMN id SET DEFAULT nextval('admin_dashboards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY banners ALTER COLUMN id SET DEFAULT nextval('banners_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY carts ALTER COLUMN id SET DEFAULT nextval('carts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies ALTER COLUMN id SET DEFAULT nextval('companies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_settings ALTER COLUMN id SET DEFAULT nextval('company_settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY custom_fields ALTER COLUMN id SET DEFAULT nextval('custom_fields_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('friendly_id_slugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY inventories ALTER COLUMN id SET DEFAULT nextval('inventories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY inventory_entries ALTER COLUMN id SET DEFAULT nextval('inventory_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY inventory_item_images ALTER COLUMN id SET DEFAULT nextval('inventory_item_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY inventory_item_prices ALTER COLUMN id SET DEFAULT nextval('inventory_item_prices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY inventory_item_properties ALTER COLUMN id SET DEFAULT nextval('inventory_item_properties_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY inventory_items ALTER COLUMN id SET DEFAULT nextval('inventory_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY manufacturers ALTER COLUMN id SET DEFAULT nextval('manufacturers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_items ALTER COLUMN id SET DEFAULT nextval('order_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_shippings ALTER COLUMN id SET DEFAULT nextval('order_shippings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payment_gateways ALTER COLUMN id SET DEFAULT nextval('payment_gateways_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payment_statuses ALTER COLUMN id SET DEFAULT nextval('payment_statuses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY people ALTER COLUMN id SET DEFAULT nextval('people_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY people_roles ALTER COLUMN id SET DEFAULT nextval('people_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pos_cash_entries ALTER COLUMN id SET DEFAULT nextval('pos_cash_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shipping_boxes ALTER COLUMN id SET DEFAULT nextval('shipping_boxes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY super_admin_users ALTER COLUMN id SET DEFAULT nextval('super_admin_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taxonomies ALTER COLUMN id SET DEFAULT nextval('taxonomies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY themes ALTER COLUMN id SET DEFAULT nextval('themes_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admin_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_dashboards
    ADD CONSTRAINT admin_dashboards_pkey PRIMARY KEY (id);


--
-- Name: admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: banners_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY banners
    ADD CONSTRAINT banners_pkey PRIMARY KEY (id);


--
-- Name: carts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: company_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY company_settings
    ADD CONSTRAINT company_settings_pkey PRIMARY KEY (id);


--
-- Name: contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: custom_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY custom_fields
    ADD CONSTRAINT custom_fields_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: good_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY inventory_entries
    ADD CONSTRAINT good_balances_pkey PRIMARY KEY (id);


--
-- Name: good_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY inventory_item_images
    ADD CONSTRAINT good_images_pkey PRIMARY KEY (id);


--
-- Name: goods_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY inventory_items
    ADD CONSTRAINT goods_pkey PRIMARY KEY (id);


--
-- Name: inventories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY inventories
    ADD CONSTRAINT inventories_pkey PRIMARY KEY (id);


--
-- Name: inventory_item_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY inventory_item_prices
    ADD CONSTRAINT inventory_item_prices_pkey PRIMARY KEY (id);


--
-- Name: inventory_item_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY inventory_item_properties
    ADD CONSTRAINT inventory_item_properties_pkey PRIMARY KEY (id);


--
-- Name: manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (id);


--
-- Name: order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: order_shippings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY order_shippings
    ADD CONSTRAINT order_shippings_pkey PRIMARY KEY (id);


--
-- Name: orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: payment_gateways_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY payment_gateways
    ADD CONSTRAINT payment_gateways_pkey PRIMARY KEY (id);


--
-- Name: payment_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY payment_statuses
    ADD CONSTRAINT payment_statuses_pkey PRIMARY KEY (id);


--
-- Name: people_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY people_roles
    ADD CONSTRAINT people_roles_pkey PRIMARY KEY (id);


--
-- Name: pos_cash_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pos_cash_entries
    ADD CONSTRAINT pos_cash_entries_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: shipping_boxes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shipping_boxes
    ADD CONSTRAINT shipping_boxes_pkey PRIMARY KEY (id);


--
-- Name: super_admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY super_admin_users
    ADD CONSTRAINT super_admin_users_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: taxonomies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taxonomies
    ADD CONSTRAINT taxonomies_pkey PRIMARY KEY (id);


--
-- Name: themes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY themes
    ADD CONSTRAINT themes_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY people
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: company_settings_gist_settings; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX company_settings_gist_settings ON company_settings USING gist (settings);


--
-- Name: customer_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX customer_email ON people USING gin (to_tsvector('english'::regconfig, (email)::text));


--
-- Name: customer_first_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX customer_first_name ON people USING gin (to_tsvector('english'::regconfig, first_name));


--
-- Name: customer_last_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX customer_last_name ON people USING gin (to_tsvector('english'::regconfig, first_name));


--
-- Name: customer_social_security_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX customer_social_security_number ON people USING gin (to_tsvector('english'::regconfig, (social_security_number)::text));


--
-- Name: good_description; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX good_description ON inventory_items USING gin (to_tsvector('english'::regconfig, description));


--
-- Name: good_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX good_name ON inventory_items USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: index_addresses_on_addressable_id_and_addressable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_addressable_id_and_addressable_type ON addresses USING btree (addressable_id, addressable_type);


--
-- Name: index_addresses_on_default; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_default ON addresses USING btree ("default");


--
-- Name: index_admin_users_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_admin_users_on_company_id ON admin_users USING btree (company_id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);


--
-- Name: index_banners_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_banners_on_company_id ON banners USING btree (company_id);


--
-- Name: index_carts_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_carts_on_company_id ON carts USING btree (company_id);


--
-- Name: index_carts_on_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_carts_on_customer_id ON carts USING btree (customer_id);


--
-- Name: index_carts_on_environment; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_carts_on_environment ON carts USING btree (environment);


--
-- Name: index_carts_on_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_carts_on_uuid ON carts USING btree (uuid);


--
-- Name: index_companies_on_domain; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_companies_on_domain ON companies USING btree (domain);


--
-- Name: index_companies_on_handle; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_companies_on_handle ON companies USING btree (handle);


--
-- Name: index_companies_on_theme_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_companies_on_theme_id ON companies USING btree (theme_id);


--
-- Name: index_company_settings_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_company_settings_on_company_id ON company_settings USING btree (company_id);


--
-- Name: index_contacts_on_contactable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_contacts_on_contactable_id ON contacts USING btree (contactable_id);


--
-- Name: index_contacts_on_contactable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_contacts_on_contactable_type ON contacts USING btree (contactable_type);


--
-- Name: index_custom_fields_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_custom_fields_on_company_id ON custom_fields USING btree (company_id);


--
-- Name: index_custom_fields_on_related_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_custom_fields_on_related_type ON custom_fields USING btree (related_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON friendly_id_slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_inventory_entries_on_admin_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_entries_on_admin_user_id ON inventory_entries USING btree (admin_user_id);


--
-- Name: index_inventory_entries_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_entries_on_inventory_item_id ON inventory_entries USING btree (inventory_item_id);


--
-- Name: index_inventory_entries_on_on_sale; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_entries_on_on_sale ON inventory_entries USING btree (on_sale);


--
-- Name: index_inventory_entries_on_point_of_sale; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_entries_on_point_of_sale ON inventory_entries USING btree (point_of_sale);


--
-- Name: index_inventory_entries_on_store_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_entries_on_store_id ON inventory_entries USING btree (store_id);


--
-- Name: index_inventory_item_images_on_cover; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_item_images_on_cover ON inventory_item_images USING btree (cover);


--
-- Name: index_inventory_item_images_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_item_images_on_inventory_item_id ON inventory_item_images USING btree (inventory_item_id);


--
-- Name: index_inventory_item_prices_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_item_prices_on_inventory_item_id ON inventory_item_prices USING btree (inventory_item_id);


--
-- Name: index_inventory_item_properties_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_item_properties_on_inventory_item_id ON inventory_item_properties USING btree (inventory_item_id);


--
-- Name: index_inventory_items_on_barcode; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_items_on_barcode ON inventory_items USING btree (barcode);


--
-- Name: index_inventory_items_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_items_on_company_id ON inventory_items USING btree (company_id);


--
-- Name: index_inventory_items_on_custom_fields; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_items_on_custom_fields ON inventory_items USING gin (custom_fields);


--
-- Name: index_inventory_items_on_manufacturer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_items_on_manufacturer_id ON inventory_items USING btree (manufacturer_id);


--
-- Name: index_inventory_items_on_reference_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_items_on_reference_number ON inventory_items USING btree (reference_number);


--
-- Name: index_inventory_items_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_items_on_slug ON inventory_items USING btree (slug);


--
-- Name: index_inventory_items_on_taxonomy_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_items_on_taxonomy_id ON inventory_items USING btree (taxonomy_id);


--
-- Name: index_inventory_items_on_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_items_on_uuid ON inventory_items USING btree (uuid);


--
-- Name: index_manufacturers_on_admin_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_manufacturers_on_admin_user_id ON manufacturers USING btree (admin_user_id);


--
-- Name: index_manufacturers_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_manufacturers_on_company_id ON manufacturers USING btree (company_id);


--
-- Name: index_order_items_on_cart_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_order_items_on_cart_id ON order_items USING btree (cart_id);


--
-- Name: index_order_items_on_inventory_entry_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_order_items_on_inventory_entry_id ON order_items USING btree (inventory_entry_id);


--
-- Name: index_order_items_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_order_items_on_inventory_item_id ON order_items USING btree (inventory_item_id);


--
-- Name: index_order_items_on_order_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_order_items_on_order_id ON order_items USING btree (order_id);


--
-- Name: index_order_items_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_order_items_on_parent_id ON order_items USING btree (parent_id);


--
-- Name: index_order_items_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_order_items_on_status ON order_items USING btree (status);


--
-- Name: index_order_items_on_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_order_items_on_uuid ON order_items USING btree (uuid);


--
-- Name: index_order_shippings_on_cart_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_order_shippings_on_cart_id ON order_shippings USING btree (cart_id);


--
-- Name: index_order_shippings_on_order_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_order_shippings_on_order_id ON order_shippings USING btree (order_id);


--
-- Name: index_orders_on_admin_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orders_on_admin_user_id ON orders USING btree (admin_user_id);


--
-- Name: index_orders_on_cart_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orders_on_cart_id ON orders USING btree (cart_id);


--
-- Name: index_orders_on_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orders_on_customer_id ON orders USING btree (customer_id);


--
-- Name: index_orders_on_environment; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orders_on_environment ON orders USING btree (environment);


--
-- Name: index_orders_on_store_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orders_on_store_id ON orders USING btree (store_id);


--
-- Name: index_orders_on_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orders_on_uuid ON orders USING btree (uuid);


--
-- Name: index_pages_on_admin_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_admin_user_id ON pages USING btree (admin_user_id);


--
-- Name: index_pages_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_company_id ON pages USING btree (company_id);


--
-- Name: index_payment_gateways_on_store_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payment_gateways_on_store_id ON payment_gateways USING btree (store_id);


--
-- Name: index_payment_statuses_on_order_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payment_statuses_on_order_id ON payment_statuses USING btree (order_id);


--
-- Name: index_payment_statuses_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payment_statuses_on_status ON payment_statuses USING btree (status);


--
-- Name: index_people_on_authentication_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_people_on_authentication_token ON people USING btree (authentication_token);


--
-- Name: index_people_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_people_on_confirmation_token ON people USING btree (confirmation_token);


--
-- Name: index_people_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_people_on_email ON people USING btree (email);


--
-- Name: index_people_on_enabled; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_people_on_enabled ON people USING btree (enabled);


--
-- Name: index_people_on_environment; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_people_on_environment ON people USING btree (environment);


--
-- Name: index_people_on_receive_newsletter; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_people_on_receive_newsletter ON people USING btree (receive_newsletter);


--
-- Name: index_people_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_people_on_reset_password_token ON people USING btree (reset_password_token);


--
-- Name: index_people_on_store_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_people_on_store_id ON people USING btree (store_id);


--
-- Name: index_people_on_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_people_on_uuid ON people USING btree (uuid);


--
-- Name: index_people_roles_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_people_roles_on_person_id ON people_roles USING btree (person_id);


--
-- Name: index_people_roles_on_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_people_roles_on_role_id ON people_roles USING btree (role_id);


--
-- Name: index_pos_cash_entries_on_admin_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pos_cash_entries_on_admin_user_id ON pos_cash_entries USING btree (admin_user_id);


--
-- Name: index_pos_cash_entries_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pos_cash_entries_on_company_id ON pos_cash_entries USING btree (company_id);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_roles_on_name ON roles USING btree (name);


--
-- Name: index_shipping_boxes_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shipping_boxes_on_inventory_item_id ON shipping_boxes USING btree (inventory_item_id);


--
-- Name: index_super_admin_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_super_admin_users_on_email ON super_admin_users USING btree (email);


--
-- Name: index_super_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_super_admin_users_on_reset_password_token ON super_admin_users USING btree (reset_password_token);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);


--
-- Name: index_taxonomies_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxonomies_on_parent_id ON taxonomies USING btree (parent_id);


--
-- Name: index_taxonomies_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxonomies_on_slug ON taxonomies USING btree (slug);


--
-- Name: index_taxonomies_on_store_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxonomies_on_store_id ON taxonomies USING btree (store_id);


--
-- Name: index_taxonomy_hierarchies_on_ancestor_id_and_descendant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_taxonomy_hierarchies_on_ancestor_id_and_descendant_id ON taxonomy_hierarchies USING btree (ancestor_id, descendant_id);


--
-- Name: index_taxonomy_hierarchies_on_descendant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxonomy_hierarchies_on_descendant_id ON taxonomy_hierarchies USING btree (descendant_id);


--
-- Name: index_themes_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_themes_on_company_id ON themes USING btree (company_id);


--
-- Name: inventory_item_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX inventory_item_name ON inventory_items USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: item_properties; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX item_properties ON inventory_item_properties USING gin (properties);


--
-- Name: manufacturers_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX manufacturers_name ON manufacturers USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX taggings_idx ON taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: taxonomies_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX taxonomies_name ON taxonomies USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

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

INSERT INTO schema_migrations (version) VALUES ('20130605171558');

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
