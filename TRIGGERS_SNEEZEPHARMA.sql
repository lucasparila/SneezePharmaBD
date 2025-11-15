USE SneezePharma;
GO

GO
CREATE OR ALTER TRIGGER trg_ValidarVendaMedicamento
ON VendasMedicamentos
AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN Clientes c
		ON i.IdCliente = c.Id
		WHERE c.DataNascimento > DATEADD(YEAR, -18, GETDATE())
	)
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 50001, 'Cliente deve ter m�nimo de 18 anos para realizar compra!', 16;
	END

	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN Clientes c
		ON i.IdCliente = c.Id
		LEFT JOIN ClientesRestritos cr
		ON c.Id = cr.IdCliente
		WHERE c.Situacao = 'I' OR cr.IdCliente IS NOT NULL
	)
	BEGIN 
		ROLLBACK TRANSACTION;
		THROW 50002, 'Cliente inativo ou restringido!', 16;
	END

	UPDATE c
	SET c.DataUltimaCompra = GETDATE()
	FROM Clientes c
	JOIN inserted i
	ON c.Id = i.IdCliente;

END;
GO

GO
CREATE OR ALTER TRIGGER trg_ValidarItensVendas
ON ItensVendas
INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN Medicamentos m
		ON i.CDBMedicamento = m.CDB
		LEFT JOIN Producoes p
		ON p.CDBMedicamento = m.CDB
		WHERE m.Situacao = 'I' OR p.CDBMedicamento IS NULL
	)
	BEGIN
		THROW 50017, 'Medicamento est� inativo ou ainda n�o foi produzido!', 16;
	END
	
	IF ((SELECT COUNT(*) FROM inserted) > 3)
    BEGIN
        THROW 50020, 'Cada venda s� pode ter at� 3 registros de medicamentos!', 16;
	END
	
	IF ((SELECT COUNT(*) FROM inserted) < 1)
    BEGIN
        THROW 50021, '� necess�rio selecionar pelo menos 1 medicamento para realizar a venda!', 16;
	END

	INSERT INTO ItensVendas (Quantidade, IdVenda, CDBMedicamento)
	SELECT Quantidade, IdVenda, CDBMedicamento
	FROM inserted;
END;
GO

GO
CREATE OR ALTER TRIGGER trg_AtualizarValorTotalItensVendas
ON ItensVendas
AFTER INSERT
AS
BEGIN
	UPDATE iv
	SET iv.ValorTotal = m.ValorVenda * iv.Quantidade
	FROM ItensVendas iv
	INNER JOIN inserted i 
    ON iv.IdVenda = i.IdVenda
	AND iv.CDBMedicamento = i.CDBMedicamento
	INNER JOIN Medicamentos m 
    ON m.CDB = iv.CDBMedicamento;
END;
GO

GO
CREATE OR ALTER TRIGGER trg_AtualizarUltimaVendaMedicamentos
ON ItensVendas
AFTER INSERT
AS
BEGIN
	UPDATE m 
    SET m.DataUltimaVenda = GETDATE()
    FROM Medicamentos m
    INNER JOIN inserted i 
	ON m.CDB = i.CDBMedicamento;
END;
GO

GO
CREATE OR ALTER TRIGGER trg_AtualizarValorTotalVendas
ON ItensVendas
AFTER INSERT
AS
BEGIN
	UPDATE vm
	SET vm.ValorTotal = (SELECT SUM(ValorTotal) 
                        FROM ItensVendas iv 
                        WHERE iv.IdVenda = vm.Id)
	FROM VendasMedicamentos vm
	INNER JOIN inserted i 
	ON vm.Id = i.IdVenda;
END;
GO



-- Verifica se o Fornecedor possu� mais de dois anos de funda��o, se ele est� ativo e se ele n�o est� restrito. Se acontecer o insert,
-- atualiza a data do �ltimo fornecimento do Fornecedor
GO
CREATE OR ALTER TRIGGER trg_ValidarCompraIngrediente
ON Compras
AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN Fornecedores f
		ON i.IdFornecedor = f.Id
		WHERE f.DataAbertura > DATEADD(YEAR, -2, GETDATE())
	)
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 50001, 'Fornecedor precisa ter no m�nimo dois anos de funda��o para poder realizar uma venda!', 16;
	END
	
	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN Fornecedores f
		ON i.IdFornecedor = f.Id
		LEFT JOIN FornecedoresRestritos fr
		ON f.Id = fr.IdFornecedor
		WHERE f.Situacao = 'I' OR fr.IdFornecedor IS NOT NULL
	)
	BEGIN 
		ROLLBACK TRANSACTION;
		THROW 50002, 'Fornecedor inativo ou restringido!', 16;
	END
	
	UPDATE f
    SET f.DataUltimoFornecimento = GETDATE()
    FROM Fornecedores f
    INNER JOIN inserted i 
	ON f.Id = i.IdFornecedor;
END;
GO

-- verifica se j� n�o existe tr�s registro na tabela ItensCompras relacionado ao IdCompra da inser�ao; verifica se o principio ativo
-- informado pa a inser�ao est� ativo; se a inser��o der certo, atualiza a data da ultima compra na tabela PrincipiosAtivos 
-- e atualiza ValorTotal na tabela Compras
GO
CREATE OR ALTER TRIGGER trg_ValidarItensCompras
ON ItensCompras
INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN PrincipiosAtivos pa
		ON i.IdPrincipioAtivo = pa.Id
		WHERE pa.Situacao = 'I'
	)
	BEGIN
		THROW 50001, 'Princ�pio Ativo est� inativo!', 16;
	END

	IF ((SELECT COUNT(*) FROM inserted) > 3)
    BEGIN
        THROW 50020, 'Cada compra s� pode ter at� 3 registros de princ�pios ativos!', 16;
	END
	
	IF ((SELECT COUNT(*) FROM inserted) < 1)
    BEGIN
        THROW 50021, '� necess�rio selecionar pelo menos 1 princ�pio ativo para realizar a compra!', 16;
	END

	-- insere na tabela ItensCompra
	INSERT INTO ItensCompras (Quantidade, ValorUnitario, IdCompra, IdPrincipioAtivo)
	SELECT Quantidade, ValorUnitario, IdCompra, IdPrincipioAtivo
	FROM inserted;
END; 
GO

GO
CREATE OR ALTER TRIGGER trg_AtualizarUltimaCompraPrincipiosAtivos
ON ItensCompras
AFTER INSERT
AS
BEGIN
	UPDATE pa 
    SET pa.UltimaCompra = GETDATE()
    FROM PrincipiosAtivos pa
    INNER JOIN inserted i 
	ON pa.Id = i.IdPrincipioAtivo;
END;
GO

GO
CREATE OR ALTER TRIGGER trg_AtualizarValorTotalCompras
ON ItensCompras
AFTER INSERT
AS
BEGIN
	UPDATE c
	SET c.ValorTotal = (SELECT SUM(ValorTotal) 
                        FROM ItensCompras ic 
                        WHERE ic.IdCompra = c.Id)
	FROM Compras c
	INNER JOIN inserted i 
	ON c.Id = i.IdCompra;
END;
GO



-- Producoes --
GO
CREATE OR ALTER TRIGGER trg_ValidarProducoes
ON Producoes
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN Medicamentos m
		ON i.CDBMedicamento = m.CDB
		WHERE m.Situacao = 'I'
	)
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 50041, 'O medicamento informado n�o pode ser produzido, pois est� inativo!', 16;
	END
END;
GO

-- ItensDeProducao --
GO
CREATE OR ALTER TRIGGER trg_ValidarItensProducoes
ON ItensProducoes
INSTEAD OF INSERT
AS
BEGIN
	SET NOCOUNT ON

	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN PrincipiosAtivos pa
		ON i.IdPrincipioAtivo = pa.Id
		WHERE pa.Situacao = 'I'
	)
	BEGIN
		THROW 50041, 'Princ�pio Ativo est� inativo!', 16;
	END

	IF ((SELECT COUNT(*) FROM inserted) < 1)
    BEGIN
        THROW 50021, '� necess�rio selecionar pelo menos 1 princ�pio ativo para realizar a produ��o!', 16;
	END

	INSERT INTO ItensProducoes (QuantidadePrincipio, IdPrincipioAtivo, IdProducao)
	SELECT QuantidadePrincipio, IdPrincipioAtivo, IdProducao
	FROM inserted;
END;
GO


-- // TRIGGERS DE DELETE \\ --

-- Clientes --
GO
CREATE OR ALTER TRIGGER trg_DeletarCliente
ON Clientes
INSTEAD OF DELETE
AS
BEGIN
	THROW 50020, 'Opera��o DELETE n�o autorizada na tabela Clientes', 16;	
END;
GO

-- Fornecedores --
GO
CREATE OR ALTER TRIGGER trg_DeletarFornecedor
ON Fornecedores
INSTEAD OF DELETE
AS
BEGIN
	THROW 50021, 'Opera��o DELETE n�o autorizada na tabela Fornecedores', 16;	
END;
GO

-- PrincipioAtivo --
GO
CREATE OR ALTER TRIGGER trg_DeletarPrincipioAtivo
ON PrincipiosAtivos
INSTEAD OF DELETE
AS
BEGIN
	THROW 50022, 'Opera��o DELETE n�o autorizada na tabela PrincipiosAtivos', 16;	
END;
GO

-- Medicamentos --
GO
CREATE OR ALTER TRIGGER trg_DeletarMedicamento
ON Medicamentos
INSTEAD OF DELETE
AS
BEGIN
	THROW 50023, 'Opera��o DELETE n�o autorizada na tabela Medicamentos', 16;	
END;
GO