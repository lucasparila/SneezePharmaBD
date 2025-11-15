Use SneezePharma;
GO

-- Enderecos Clientes --
INSERT INTO EnderecosClientes VALUES ('Av. Princesa Isabel', 505, NULL, 'Maria Luiza', 'Aracity', 'SP', 14820055);
INSERT INTO EnderecosClientes VALUES ('Rua Bananinha', 1023, 'Em frente a bananeira', 'Santana', 'Bananacity', 'MG', 31471844);
INSERT INTO EnderecosClientes VALUES ('Rua das Flores', 32, NULL, 'Jardim Primavera', 'Americo Brasiliense', 'SP', 14820000);

-- Situacoes --
INSERT INTO Situacoes VALUES
('A', 'Ativo'),
('I', 'Inativo');

-- Clientes --

DECLARE @cliente Tipo_Clientes;
DECLARE @telefonesCliente Tipo_TelefonesClientes
DECLARE @emailsCliente Tipo_EmailsClientes

-- cliente 1 --
INSERT INTO @cliente
VALUES
('Jo�o', 43209614501, '1993-05-16', 1, 'A');
INSERT INTO @telefonesCliente
VALUES
(55, 16, 997525125);
INSERT INTO @emailsCliente
VALUES 
('joao@gmail.com', 1);
exec sp_CadastrarClientes @cliente, @telefonesCliente, @emailsCliente;

DELETE FROM @cliente;
DELETE FROM @telefonesCliente;
DELETE FROM @emailsCliente;

-- cliente 2 --
INSERT INTO @cliente
VALUES
('Jos�', 85031531513, '2009-05-12', 1, 'A');
INSERT INTO @telefonesCliente
VALUES
(55, 16, 995238537);
INSERT INTO @emailsCliente
VALUES 
('josesito@gmail.com');
exec sp_CadastrarClientes @cliente, @telefonesCliente, @emailsCliente;

DELETE FROM @cliente;
DELETE FROM @telefonesCliente;
DELETE FROM @emailsCliente;

-- cliente 3 --

INSERT INTO @cliente
VALUES
('Juca', 38030851751, '1986-10-23', 3, 'I');
INSERT INTO @telefonesCliente
VALUES
(55, 31, 994355165);
INSERT INTO @emailsCliente
VALUES 
('zebacana@outlook.com');
exec sp_CadastrarClientes @cliente, @telefonesCliente, @emailsCliente;

DELETE FROM @cliente;
DELETE FROM @telefonesCliente;
DELETE FROM @emailsCliente;

-- cliente 4 --

INSERT INTO @cliente
VALUES
('Roberta', 43145105632, '2001-05-06', 2, 'A');
INSERT INTO @telefonesCliente
VALUES
(55, 16, 997415312);
INSERT INTO @emailsCliente
VALUES 
('roberta@hotmail.com');
exec sp_CadastrarClientes @cliente, @telefonesCliente, @emailsCliente;

DELETE FROM @cliente;
DELETE FROM @telefonesCliente;
DELETE FROM @emailsCliente;

-- ClientesRestritos --
INSERT INTO ClientesRestritos VALUES (4);



-- CategoriasMedicamentos --
INSERT INTO CategoriasMedicamentos VALUES
('A', 'Analg�sico'),
('B', 'Antibiotico'),
('I', 'Antiflamat�rio'),
('V', 'Vitamina');

-- Medicamentos --
INSERT INTO Medicamentos VALUES
('7891234567890', 'Tyfadol', 8.50, GETDATE(), NULL, 'A', 'A'),
('7891234567891', 'Dorax', 10.20, GETDATE(), NULL, 'A', 'A'),
('7891234567892', 'Amoxilina', 32, GETDATE(), NULL, 'A', 'B'),
('7891234567893', 'Ibuprofeno', 10.50, GETDATE(), NULL, 'I', 'I'),
('7891234567894', 'Vitamina C', 5.65, GETDATE(), NULL, 'A', 'V');


-- Principios Ativos -- 

-- Paracetamol - ativo
INSERT INTO PrincipiosAtivos (Id, Nome, DataCadastro, UltimaCompra, Situacao)
VALUES ('AI0001', 'Paracetamol', '2015-05-10', '2025-09-22', 'A');

-- Ibuprofeno - ativo
INSERT INTO PrincipiosAtivos (Id, Nome, DataCadastro, UltimaCompra, Situacao)
VALUES ('AI0002', 'Ibuprofeno', '2016-11-03', '2025-10-10', 'A');

-- Amoxicilina - ativo
INSERT INTO PrincipiosAtivos (Id, Nome, DataCadastro, UltimaCompra, Situacao)
VALUES ('AI0003', 'Amoxicilina', '2018-07-20', '2025-06-18', 'A');

-- Dipirona S�dica - ativo
INSERT INTO PrincipiosAtivos (Id, Nome, DataCadastro, UltimaCompra, Situacao)
VALUES ('AI0004', 'Dipirona S�dica', '2014-03-12', '2024-12-30', 'A');

-- Cloroquina (inativo, uso restrito)
INSERT INTO PrincipiosAtivos (Id, Nome, DataCadastro, UltimaCompra, Situacao)
VALUES ('AI0005', 'Cloroquina', '2010-01-05', '2020-05-15', 'I');


-- Fornecedores --
DECLARE @fornecedor Tipo_Fornecedores;
DECLARE @enderecosFornecedor Tipo_EnderecosFornecedores;
DECLARE @telefonesFornecedor Tipo_TelefonesFornecedores;
DECLARE @emailFornecedor Tipo_EmailsFornecedores;

-- fornecedor 1: empresa antiga e ativa
INSERT INTO @fornecedor
VALUES
('Farm�cia Sa�de Total LTDA', 12345678000199, '2015-03-12', 'A');

INSERT INTO @enderecosFornecedor
VALUES
('Rua das Flores', 120, 'Loja 1', 'Centro', 'S�o Paulo', 'SP', 'Brasil', 01020000);

INSERT INTO @telefonesFornecedor
VALUES 
(55, 11, '33402515');

INSERT INTO @emailFornecedor
VALUEs
('farmaciasaude@farmaciasaude.com');

exec sp_CadastrarFornecedor @fornecedor, @enderecosFornecedor, @telefonesFornecedor, @emailFornecedor;

DELETE FROM @fornecedor;
DELETE FROM @enderecosFornecedor;
DELETE FROM @telefonesCliente;
DELETE FROM @emailFornecedor;

-- fornecedor 2 -- 

INSERT INTO @fornecedor
VALUES
('Drogaria Popular EIRELI', 98765432000188, '2024-09-05', NULL, '2024-09-05', 'A');

INSERT INTO @enderecosFornecedor
VALUES
('Avenida Brasil', 502, NULL, 'Jardim Am�rica', 'Belo Horizonte', 'MG', 'Brasil', 30140000);

INSERT INTO @telefonesFornecedor
VALUES 
(55, 31, '32041538');

INSERT INTO @emailFornecedor
VALUEs
('drogariapopular@outlook.com');

exec sp_CadastrarFornecedor @fornecedor, @enderecosFornecedor, @telefonesFornecedor, @emailFornecedor;

DELETE FROM @fornecedor;
DELETE FROM @enderecosFornecedor;
DELETE FROM @telefonesCliente;
DELETE FROM @emailFornecedor;

-- fornecedor 3 -- 

INSERT INTO @fornecedor
VALUES
('Distribuidora Vida Mais LTDA', 45678912000177, '2012-05-20', '2023-12-10', '2015-05-20', 'I');

INSERT INTO @enderecosFornecedor
VALUES
('Rua do Com�rcio', 75, 'Sala 3', 'Centro', 'Curitiba', 'PR', 'Brasil', 80020000);

INSERT INTO @telefonesFornecedor
VALUES 
(55, 41, '30451965');

INSERT INTO @emailFornecedor
VALUEs
('vidamais@vidaltda.com');

exec sp_CadastrarFornecedor @fornecedor, @enderecosFornecedor, @telefonesFornecedor, @emailFornecedor;

DELETE FROM @fornecedor;
DELETE FROM @enderecosFornecedor;
DELETE FROM @telefonesCliente;
DELETE FROM @emailFornecedor;

-- fornecedor 4 --

INSERT INTO @fornecedor
VALUES
('Laborat�rio S�o Lucas S/A', 22334455000166, '2018-11-02', '2025-07-01', '2019-11-02', 'A');

INSERT INTO @enderecosFornecedor
VALUES
('Avenida Independ�ncia', 980, NULL, 'Cidade Baixa', 'Porto Alegre', 'RS', 'Brasil', 90035000);

INSERT INTO @telefonesFornecedor
VALUES 
(NULL, NULL, '08001459835');

INSERT INTO @emailFornecedor
VALUEs
('labsaolucas@labsl.com');

exec sp_CadastrarFornecedor @fornecedor, @enderecosFornecedor, @telefonesFornecedor, @emailFornecedor;

DELETE FROM @fornecedor;
DELETE FROM @enderecosFornecedor;
DELETE FROM @telefonesCliente;
DELETE FROM @emailFornecedor;

-- fornecedor 5 --

INSERT INTO @fornecedor
VALUES
('BioMedic Distribuidora LTDA', 33445566000155, '2010-01-18', '2025-10-10', '2010-01-18', 'A');

INSERT INTO @enderecosFornecedor
VALUES
('Rua das Palmeiras', 240, 'Galp�o 2', 'Boa Viagem', 'Recife', 'PE', 'Brasil', 51021000);

INSERT INTO @telefonesFornecedor
VALUES 
(55, 81, '40531552');

INSERT INTO @emailFornecedor
VALUES
('biomedic@gmail.com');

exec sp_CadastrarFornecedor @fornecedor, @enderecosFornecedor, @telefonesFornecedor, @emailFornecedor;

DELETE FROM @fornecedor;
DELETE FROM @enderecosFornecedor;
DELETE FROM @telefonesCliente;
DELETE FROM @emailFornecedor;

-- FornecedoresRestritos -- 
INSERT INTO FornecedoresRestritos(IdFornecedor) VALUES (4);

select * from Medicamentos;
select * from PrincipiosAtivos;


-- Compras --
DECLARE @itensCompra Tipo_ItensCompras;


-- Compra 1 --

INSERT INTO @itensCompra
VALUES
(10, 5.50, 1, 'AI0001'),
(10, 10.50, 1, 'AI0002'),
(10, 24.50, 1, 'AI0003');
-- (10, 5.50, 1, 'AI0004'); dá erro. Uma compra só pode ter três itens
exec sp_Compras 1, @itensCompra;
DELETE FROM @itensCompra;

-- Compra 2 - empresa nova (menos de 2 anos) - d� erro
--INSERT INTO @itensCompra
--VALUES
--(10, 5.50, 1, 'AI0001'),
--(10, 10.50, 1, 'AI0002');
--exec sp_Compras 2, @itensCompra;
--DELETE FROM @itensCompra;

-- Compra 3 -empresa inativa - da erro
--INSERT INTO @itensCompra
--VALUES
--(10, 10.50, 1, 'AI0002');
--exec sp_Compras 3, @itensCompra;
--DELETE FROM @itensCompra;

-- Compra 4 - empresa media, ativa - d� erro porque est� restrita 

--INSERT INTO @itensCompra
--VALUES
--(10, 10.50, 1, 'AI0002'),
--(10, 24.50, 1, 'AI0003');
--exec sp_Compras 4, @itensCompra;
--DELETE FROM @itensCompra;

-- Compra 5 -- 

INSERT INTO @itensCompra
VALUES
(10, 5.50, 1, 'AI0001'),
(10, 24.50, 1, 'AI0003');
exec sp_Compras 5, @itensCompra;
DELETE FROM @itensCompra;

-- Producoes --
DECLARE @itensProducoes Tipo_ItensProducoes;

-- produçao 1 --
INSERT INTO @itensProducoes
VALUES
(40, 'AI0002');
exec sp_Producoes 40,'7891234567890', @itensProducoes;
DELETE FROM @itensProducoes;

-- produção 2 --

INSERT INTO @itensProducoes
VALUES
(20, 'AI0001');
exec sp_Producoes 20,'7891234567891', @itensProducoes;
DELETE FROM @itensProducoes;

-- produção 3 --
INSERT INTO @itensProducoes
VALUES
(50, 'AI0003');
exec sp_Producoes 35,'7891234567892', @itensProducoes;
DELETE FROM @itensProducoes;

-- VendasMedicamentos --
DECLARE @itensVenda Tipo_ItensVendas;

-- venda 1-- 
INSERT INTO @itensVenda 
VALUES
(5, '7891234567890'),
(2, '7891234567891'),
(2, '7891234567892');
exec sp_VendasMedicamentos 1, @itensVenda;
DELETE FROM @itensVenda;

-- venda 2 - cliente menor de idade--

--INSERT INTO @itensVenda 
--VALUES
--(5, '7891234567890');
--exec sp_VendasMedicamentos 2, @itensVenda;
--DELETE FROM @itensVenda;

---- venda 3 - cliente inativo --
--INSERT INTO @itensVenda 
--VALUES
--(2, '7891234567892');
--exec sp_VendasMedicamentos 3, @itensVenda;
--DELETE FROM @itensVenda;


-- venda 4 - medicamento inativo --

--INSERT INTO @itensVenda 
--VALUES
--(5, '7891234567890'),
--(2, '7891234567893'),
--(2, '7891234567892');
--exec sp_VendasMedicamentos 1, @itensVenda;
--DELETE FROM @itensVenda;

