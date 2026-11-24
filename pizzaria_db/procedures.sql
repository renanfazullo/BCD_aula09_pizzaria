USE Pizzaria;

-- Verificar quais procedures o banco de dados possui
SHOW PROCEDURE STATUS;

-- Excluir procedures caso já existam
DROP PROCEDURE IF EXISTS pedidodeumitem;
DROP PROCEDURE IF EXISTS atulizaValorPedido;

-- Procedure para atualizar o valor total do pedido
DELIMITER $

CREATE PROCEDURE atulizaValorPedido(id INT)
BEGIN
    UPDATE pedidos
    SET valor = (
        SELECT COALESCE(SUM(valor * quantidade), 0)
        FROM itens_pedido
        WHERE pedido_id = id
    )
    WHERE pedido_id = id;
END$

DELIMITER ;

-- Procedure para cadastrar um pedido com um item
DELIMITER $

CREATE PROCEDURE pedidodeumitem(
    cli_id INT,
    piz_id INT,
    qtd INT
)
BEGIN
    DECLARE novo_pedido_id INT;
    DECLARE valor_pizza DECIMAL(10,2);

    INSERT INTO pedidos (cliente_id, data, hora, valor)
    VALUES (cli_id, CURDATE(), CURTIME(), NULL);

    SET novo_pedido_id = LAST_INSERT_ID();

    SELECT valor INTO valor_pizza
    FROM pizzas
    WHERE pizza_id = piz_id;

    INSERT INTO itens_pedido (pedido_id, pizza_id, quantidade, valor)
    VALUES (
        novo_pedido_id,
        piz_id,
        qtd,
        valor_pizza
    );

    CALL atulizaValorPedido(novo_pedido_id);
END$

DELIMITER ;

-- Verificar as procedures criadas
SHOW PROCEDURE STATUS;

-- Consultar os pedidos
SELECT * FROM pedidos;

-- Consultar os itens dos pedidos
SELECT * FROM itens_pedido;
