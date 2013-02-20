--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_receivables; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE account_receivables (
    id integer NOT NULL,
    company_id integer,
    admin_user_id integer,
    customer_id integer,
    value numeric,
    description text,
    due_to date,
    paid boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: account_receivables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE account_receivables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_receivables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE account_receivables_id_seq OWNED BY account_receivables.id;


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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    encrypted_password character varying(128) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    password_salt character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
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
-- Name: carts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE carts (
    id integer NOT NULL,
    user_id integer,
    company_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    environment character varying(255)
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    handle character varying(255),
    domain text
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
-- Name: customers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customers (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    description character varying(255),
    company_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customers_id_seq OWNED BY customers.id;


--
-- Name: inventories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE inventories (
    id integer NOT NULL,
    company_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    balance_type character varying(255),
    description text,
    quantity numeric,
    cost_per_unit numeric,
    moving_average_cost numeric,
    total_quantity numeric,
    total_cost numeric,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    on_sale boolean DEFAULT true,
    store_id integer
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    inventory_id integer,
    reference character varying(255),
    admin_user_id integer,
    merchandising text,
    taxonomy_id integer,
    year integer,
    manufacturer_id integer
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status character varying(255)
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    user_id integer,
    store_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    environment character varying(255)
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
-- Name: payment_gateways; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE payment_gateways (
    id integer NOT NULL,
    store_id integer,
    name character varying(255),
    email character varying(255),
    token text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
-- Name: taxonomies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taxonomies (
    id integer NOT NULL,
    name text,
    parent_id integer,
    store_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
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
    store_id integer
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_receivables ALTER COLUMN id SET DEFAULT nextval('account_receivables_id_seq'::regclass);


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

ALTER TABLE ONLY customers ALTER COLUMN id SET DEFAULT nextval('customers_id_seq'::regclass);


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

ALTER TABLE ONLY payment_gateways ALTER COLUMN id SET DEFAULT nextval('payment_gateways_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payment_statuses ALTER COLUMN id SET DEFAULT nextval('payment_statuses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shipping_boxes ALTER COLUMN id SET DEFAULT nextval('shipping_boxes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taxonomies ALTER COLUMN id SET DEFAULT nextval('taxonomies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: account_receivables_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_receivables
    ADD CONSTRAINT account_receivables_pkey PRIMARY KEY (id);


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
-- Name: customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


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
-- Name: inventory_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY inventory_entries
    ADD CONSTRAINT inventory_entries_pkey PRIMARY KEY (id);


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
-- Name: shipping_boxes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shipping_boxes
    ADD CONSTRAINT shipping_boxes_pkey PRIMARY KEY (id);


--
-- Name: taxonomies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taxonomies
    ADD CONSTRAINT taxonomies_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: company_settings_gist_settings; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX company_settings_gist_settings ON company_settings USING gist (settings);


--
-- Name: index_account_receivables_on_admin_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_account_receivables_on_admin_user_id ON account_receivables USING btree (admin_user_id);


--
-- Name: index_account_receivables_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_account_receivables_on_company_id ON account_receivables USING btree (company_id);


--
-- Name: index_account_receivables_on_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_account_receivables_on_customer_id ON account_receivables USING btree (customer_id);


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
-- Name: index_carts_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_carts_on_company_id ON carts USING btree (company_id);


--
-- Name: index_carts_on_environment; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_carts_on_environment ON carts USING btree (environment);


--
-- Name: index_carts_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_carts_on_user_id ON carts USING btree (user_id);


--
-- Name: index_companies_on_domain; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_companies_on_domain ON companies USING btree (domain);


--
-- Name: index_companies_on_handle; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_companies_on_handle ON companies USING btree (handle);


--
-- Name: index_company_settings_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_company_settings_on_company_id ON company_settings USING btree (company_id);


--
-- Name: index_customers_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_customers_on_company_id ON customers USING btree (company_id);


--
-- Name: index_good_balances_on_admin_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_good_balances_on_admin_user_id ON inventory_entries USING btree (admin_user_id);


--
-- Name: index_good_balances_on_good_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_good_balances_on_good_id ON inventory_entries USING btree (inventory_item_id);


--
-- Name: index_good_images_on_cover; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_good_images_on_cover ON inventory_item_images USING btree (cover);


--
-- Name: index_good_images_on_good_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_good_images_on_good_id ON inventory_item_images USING btree (inventory_item_id);


--
-- Name: index_goods_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_goods_on_company_id ON inventory_items USING btree (company_id);


--
-- Name: index_inventory_entries_on_on_sale; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_entries_on_on_sale ON inventory_entries USING btree (on_sale);


--
-- Name: index_inventory_entries_on_store_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_entries_on_store_id ON inventory_entries USING btree (store_id);


--
-- Name: index_inventory_item_prices_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_item_prices_on_inventory_item_id ON inventory_item_prices USING btree (inventory_item_id);


--
-- Name: index_inventory_item_properties_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_item_properties_on_inventory_item_id ON inventory_item_properties USING btree (inventory_item_id);


--
-- Name: index_inventory_items_on_manufacturer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_items_on_manufacturer_id ON inventory_items USING btree (manufacturer_id);


--
-- Name: index_inventory_items_on_taxonomy_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inventory_items_on_taxonomy_id ON inventory_items USING btree (taxonomy_id);


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
-- Name: index_order_items_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_order_items_on_status ON order_items USING btree (status);


--
-- Name: index_order_shippings_on_cart_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_order_shippings_on_cart_id ON order_shippings USING btree (cart_id);


--
-- Name: index_order_shippings_on_order_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_order_shippings_on_order_id ON order_shippings USING btree (order_id);


--
-- Name: index_orders_on_cart_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orders_on_cart_id ON orders USING btree (cart_id);


--
-- Name: index_orders_on_environment; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orders_on_environment ON orders USING btree (environment);


--
-- Name: index_orders_on_store_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orders_on_store_id ON orders USING btree (store_id);


--
-- Name: index_orders_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orders_on_user_id ON orders USING btree (user_id);


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
-- Name: index_shipping_boxes_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shipping_boxes_on_inventory_item_id ON shipping_boxes USING btree (inventory_item_id);


--
-- Name: index_taxonomies_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxonomies_on_parent_id ON taxonomies USING btree (parent_id);


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
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_authentication_token ON users USING btree (authentication_token);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_receive_newsletter; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_receive_newsletter ON users USING btree (receive_newsletter);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_store_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_store_id ON users USING btree (store_id);


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