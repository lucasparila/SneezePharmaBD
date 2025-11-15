USE SneezePharma;
GO

CREATE OR ALTER PROCEDURE sp_ItensVendas
@idVenda INT,
@itens Tipo_ItensVendas READONLY
AS
BEGIN
	INSERT INTO ItensVendas (Quantidade, IdVenda, CDBMedicamento)
	SELECT Quantidade, @idVenda, CDBMedicamento
	FROM @itens;
END;
GO


CREATE OR ALTER PROCEDURE sp_VendasMedicamentos
@idCliente INT,
@itens Tipo_ItensVendas READONLY
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @idVenda INT;

		INSERT INTO VendasMedicamentos (DataVenda, IdCliente) VALUES
		(GETDATE(), @idCliente);

		SET @idVenda = SCOPE_IDENTITY();

		EXEC sp_ItensVendas @idVenda, @itens;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO



CREATE OR ALTER PROCEDURE sp_ItensCompras
@idCompra INT,
@itens Tipo_ItensCompras READONLY
AS
BEGIN
	INSERT INTO ItensCompras (Quantidade, ValorUnitario, IdCompra, IdPrincipioAtivo)
	SELECT Quantidade, ValorUnitario, @idCompra, IdPrincipioAtivo 
	FROM @itens;
END;
GO


CREATE OR ALTER PROCEDURE sp_Compras
@idFornecedor INT,
@itens Tipo_ItensCompras READONLY
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @idCompra INT;

		INSERT INTO Compras (DataCompra, IdFornecedor) VALUES
		(GETDATE(), @idFornecedor);

		SET @idCompra = SCOPE_IDENTITY();

		EXEC sp_ItensCompras @idCompra, @itens;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO



CREATE OR ALTER PROCEDURE sp_ItensProducoes
@idProducao INT,
@itens Tipo_ItensProducoes READONLY
AS
BEGIN
	INSERT INTO ItensProducoes(QuantidadePrincipio, IdPrincipioAtivo, IdProducao)
	SELECT QuantidadePrincipio, IdPrincipioAtivo, @idProducao
	FROM @itens;
END;
GO


CREATE OR ALTER PROCEDURE sp_Producoes
@quantidade INT,
@cdbMedicamento NUMERIC(13,0),
@itens Tipo_ItensProducoes READONLY
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @idProducao INT;

		INSERT INTO Producoes(Quantidade, DataProducao, CDBMedicamento) VALUES
		(@quantidade, GETDATE(), @cdbMedicamento);

		SET @idProducao = SCOPE_IDENTITY();

		EXEC sp_ItensProducoes @idProducao, @itens;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_CadastrarEmailsClientes
@emails Tipo_EmailsClientes READONLY,
@idCliente int
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
	

		INSERT INTO EmailsClientes(Email, IdCliente)
		SELECT Email, @IdCliente
		FROM @emails

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_CadastrarTelefonesClientes
@telefones Tipo_TelefonesClientes READONLY,
@emails Tipo_EmailsClientes READONLY,
@idCliente int
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		INSERT INTO TelefonesClientes(CodPais, DDD, Numero, IdCliente)
		SELECT CodPais, DDD, Numero, @IdCliente
		FROM @telefones

		EXEC sp_CadastrarEmailsClientes @emails, @idCliente;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO


CREATE OR ALTER PROCEDURE sp_CadastrarClientes
@cliente Tipo_Clientes READONLY,
@telefones Tipo_TelefonesClientes READONLY,
@emails Tipo_EmailsClientes READONLY
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @idCliente INT;

		INSERT INTO Clientes(Nome, CPF, DataNascimento, DataUltimaCompra, DataCadastro,IdEndereco, Situacao)
		SELECT Nome, CPF, DataNascimento, null,GETDATE(), IdEndereco, Situacao
		FROM @cliente

		SET @idCliente = SCOPE_IDENTITY();

		EXEC sp_CadastrarTelefonesClientes @telefones, @emails, @idCliente;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO



CREATE OR ALTER PROCEDURE sp_CadastrarEmailsFornecedor
@emails Tipo_EmailsFornecedores READONLY,
@idFornecedor int
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
	

		INSERT INTO EmailsFornecedores(Email, IdFornecedor)
		SELECT Email, @IdFornecedor
		FROM @emails

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_CadastrarTelefonesFornecedor
@telefones Tipo_TelefonesFornecedores READONLY,
@emails Tipo_EmailsFornecedores READONLY,
@idFornecedor int
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		INSERT INTO TelefonesFornecedores(CodPais, DDD, Numero, IdFornecedor)
		SELECT CodPais, DDD, Numero, @IdFornecedor
		FROM @telefones

		EXEC sp_CadastrarEmailsFornecedor @emails, @idFornecedor;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_CadastrarEnderecoFornecedor
@endereco Tipo_EnderecosFornecedores READONLY,
@telefones Tipo_TelefonesFornecedores READONLY,
@emails Tipo_EmailsFornecedores READONLY,
@idFornecedor int
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		
		INSERT INTO EnderecosFornecedores(Logradouro, Numero, Complemento, Bairro, Cidade, Estado, Pais, CEP, IdFornecedor) 
		SELECT Logradouro, Numero, Complemento,Bairro, Cidade, Estado, CEP, @IdFornecedor
		from @endereco;


		EXEC sp_CadastrarTelefonesFornecedor @telefones, @emails, @idFornecedor;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO


CREATE OR ALTER PROCEDURE sp_CadastrarFornecedor
@fornecedor Tipo_Fornecedores READONLY,
@endereco Tipo_EnderecosFornecedores READONLY,
@telefones Tipo_TelefonesFornecedores READONLY,
@emails Tipo_EmailsFornecedores READONLY
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		DECLARE @idFornecedor INT;

		INSERT INTO Fornecedores(RazaoSocial, CNPJ, DataAbertura, DataUltimoFornecimento, DataCadastro, Situacao)
		SELECT RazaoSocial, CNPJ, DataAbertura,null,GETDATE(), Situacao
		FROM @fornecedor

		SET @idFornecedor = SCOPE_IDENTITY();

		EXEC sp_CadastrarEnderecoFornecedor @endereco, @telefones, @emails, @idFornecedor;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;
GO





