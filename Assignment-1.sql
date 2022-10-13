CREATE DATABASE Manufacturer;

USE Manufacturer

CREATE SCHEMA Prod_Comp;

CREATE SCHEMA Comp_Supp;


CREATE TABLE [Prod_Comp].[Prod_Comp](
	[prod_id] [int] NOT NULL,
	[comp_id] [int] NOT NULL
	PRIMARY KEY([prod_id],[comp_id]),
	[quantity_comp][int] NOT NULL
	);

CREATE TABLE [Prod_Comp].[Product](
	[prod_id] [int] PRIMARY KEY NOT NULL,
	[prod_name] [nvarchar](50) NOT NULL,
	[quantity] [int] NOT NULL
	);

CREATE TABLE [Prod_Comp].[Component](
	[comp_id] [int] PRIMARY KEY NOT NULL,
	[comp_name] [nvarchar](50) NOT NULL,
	[description][nvarchar](50) NOT NULL,
	[quantity_comp] [int] NOT NULL
	);

CREATE TABLE [Comp_Supp].[Comp_Supp](
	[supp_id] [int] NOT NULL,
	[comp_id] [int] NOT NULL
	PRIMARY KEY([supp_id],[comp_id]),
	[order_date] [date] NOT NULL,
	[quantity] [int] NOT NULL
	);
CREATE TABLE [Comp_Supp].[Supplier](
	[supp_id] [int] PRIMARY KEY NOT NULL,
	[supp_name] [nvarchar](50) NOT NULL,
	[supp_location][nvarchar](50) NOT NULL,
	[supp_country][nvarchar](50) NOT NULL,
	[is_active][bit] NOT NULL
	);

ALTER TABLE [Prod_Comp].[Prod_Comp] ADD CONSTRAINT FK_Product FOREIGN KEY (prod_id) REFERENCES [Prod_Comp].[Product] (prod_id)
ALTER TABLE Prod_Comp.Prod_Comp ADD CONSTRAINT FK_Component FOREIGN KEY (comp_id) REFERENCES Prod_Comp.Component (comp_id)




ALTER TABLE Comp_Supp.Comp_Supp ADD CONSTRAINT FK_Supplier FOREIGN KEY (supp_id) REFERENCES Comp_Supp.Supplier (supp_id)
ALTER TABLE Comp_Supp.Comp_Supp ADD CONSTRAINT FK_Component FOREIGN KEY (comp_id) REFERENCES Prod_Comp.Component (comp_id)