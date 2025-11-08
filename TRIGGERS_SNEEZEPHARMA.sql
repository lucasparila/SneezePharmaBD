CREATE TRIGGER ValidarVendaMedicamento
ON VendasMedicamentos
INSTEAD OF INSERT
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
		THROW 50001, 'Cliente deve ter mínimo de 18 anos para realizar compra!', 16;
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
		THROW 50002, 'Cliente inativo ou restringido!', 16;
	END

	INSERT INTO VendasMedicamentos (DataVenda, ValorTotal, IdCliente)
	SELECT DataVenda, NULL, IdCliente
	FROM inserted;
END;
 
DROP TRIGGER ValidarVendaMedicamento;
GO

-- Verifica se o Fornecedor possuí mais de dois anos de fundação, se ele está ativo e se ele não está restrito. Se acontecer o insert,
-- atualiza a data do último fornecimento do Fornecedor
CREATE TRIGGER ValidarCompraIngrediente
ON Compras
INSTEAD OF INSERT
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
		THROW 50001, 'Fornecedor precisa ter no mínimo dois anos de fundação para poder realizar uma venda!', 16;
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
		THROW 50002, 'Fornecedor inativo ou restringido!', 16;
	END

	-- insere na tabela Compras
	INSERT INTO Compras (DataCompra, ValorTotal, IdFornecedor)
	SELECT DataCompra, NULL, IdFornecedor
	FROM inserted;

	-- atualiza DataUltimoFornecimento na tabela Fornecedores
	UPDATE f
    SET f.DataUltimoFornecimento = GETDATE()
    FROM Fornecedores f
    INNER JOIN inserted i 
	ON f.Id = i.IdFornecedor;


END;
DROP TRIGGER ValidarCompraIngrediente;
GO

-- verifica se já não existe três registro na tabela ItensCompras relacionado ao IdCompra da inserçao; verifica se o principio ativo
-- informado pa a inserçao está ativo; se a inserção der certo, atualiza a data da ultima compra na tabela PrincipiosAtivos 
-- e atualiza ValorTotal na tabela Compras
CREATE TRIGGER ValidarItensCompras
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
		THROW 50001, 'Princípio Ativo está inativo!', 16;
	END

	IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE (SELECT COUNT(*) 
               FROM ItensCompras 
               WHERE IdCompra = i.IdCompra) >= 3
    )
    BEGIN
        THROW 50020, 'Cada compra só pode ter até 3 registros de princípios ativos!', 16;
	
	END

	-- insere na tabela ItensCompra
	INSERT INTO ItensCompras (Quantidade, ValorUnitario, ValorTotal, IdCompra, IdPrincipioAtivo)
	SELECT Quantidade, ValorUnitario, (Quantidade * ValorUnitario), IdCompra, IdPrincipioAtivo
	FROM inserted;

	-- atualiza UltimaCompra na tabela PrincipiosAtivos
	UPDATE pa 
    SET pa.UltimaCompra = GETDATE()
    FROM PrincipiosAtivos pa
    INNER JOIN inserted i 
	ON pa.Id = i.IdPrincipioAtivo;

	-- atualiza ValorTotal na tabela Compras
	UPDATE c
	SET c.ValorTotal = (SELECT SUM(ValorTotal) 
                        FROM ItensCompras ic 
                        WHERE ic.IdCompra = c.Id)
	FROM Compras c
	INNER JOIN inserted i 
	ON c.Id = i.IdCompra;
END; 
DROP TRIGGER ValidarItensCompras;
GO