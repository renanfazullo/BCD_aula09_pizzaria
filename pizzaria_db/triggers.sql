USE Pizzaria;

-- Excluir o trigger caso já exista
DROP TRIGGER IF EXISTS atualizaValorPedido;

-- Trigger para atualizar o valor do pedido após inserir um item
DELIMITER //

CREATE TRIGGER atualizaValorPedido
AFTER INSERT ON itens_pedido
FOR EACH ROW
BEGIN
    UPDATE pedidos
    SET valor = (
        SELECT COALESCE(SUM(valor * quantidade), 0)
        FROM itens_pedido
        WHERE pedido_id = NEW.pedido_id
    )
    WHERE pedido_id = NEW.pedido_id;
END//

DELIMITER ;
