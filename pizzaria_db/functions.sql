
USE Pizzaria;

-- Verificar quais functions o banco de dados possui
SHOW FUNCTION STATUS;

-- Excluir a função caso já exista
DROP FUNCTION IF EXISTS moeda;

-- Criar a função moeda
DELIMITER //

CREATE FUNCTION moeda(v DECIMAL(10,2)) RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE x VARCHAR(20);
    SET x = FORMAT(v, 2, 'de_DE');
    RETURN CONCAT('R$ ', x);
END//

DELIMITER ;

-- Testando a função
SELECT moeda(5.99);

-- Testando em uma consulta da tabela de pizzas
SELECT
    pizza_id,
    nome,
    moeda(valor) AS 'preço'
FROM pizzas;

-- Testando em uma consulta dos itens dos pedidos
SELECT
    pedido_id,
    pizza_id,
    quantidade,
    moeda(valor) AS 'valor R$',
    moeda(quantidade * valor) AS 'subtotal R$'
FROM itens_pedido;
