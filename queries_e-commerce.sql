
desc clients;
desc client_payments;
desc form_payments;
select * from form_payments;

-- Recuperação Simples com SELECT

SELECT * FROM clients;
-- Filtro com WHERE

SELECT * FROM orders WHERE orderStatus = 'Confirmado';
-- Criando Atributos Derivados (Valor Total do Pedido)

SELECT idOrder, orderDescription, sendValue, 
       sendValue * 1.10 AS ValorFinalComTaxa 
FROM orders;

-- Ordenação com ORDER BY
SELECT * FROM product ORDER BY avaliacao DESC;

-- Filtros em Grupos com HAVING
SELECT idOrderClient, COUNT(*) AS qtd_pedidos
FROM orders
GROUP BY idOrderClient
HAVING COUNT(*) > 1;

 -- Junção de Tabelas 
SELECT c.Fname, o.idOrder, o.orderStatus, fp.descrition AS FormaPagamento
FROM clients c
JOIN orders o ON c.idClient = o.idOrderClient
JOIN client_payments cp ON c.idClient = cp.id_client
JOIN form_payments fp ON cp.id_payments = fp.id;

--  3.7 Clientes e Suas Formas de Pagamento
SELECT c.Fname, fp.descrition
FROM clients c
JOIN client_payments cp ON c.idClient = cp.id_client
JOIN form_payments fp ON cp.id_payments = fp.id;

-- Produtos com Estoque Disponível

SELECT p.Pname, ps.quantity
FROM product p
JOIN productStorage ps ON p.idProduct = ps.idProdStorage
WHERE ps.quantity > 0;

SELECT 
    o.idOrder,
    c.Fname AS Cliente,
    SUM(po.poQuantity) AS TotalItens,
    SUM(po.poQuantity * p.avaliação) AS ValorTotal,
    CASE 
        WHEN SUM(po.poQuantity) > 9 THEN SUM(po.poQuantity * p.avaliação) * 0.90 -- 10% de desconto
        ELSE SUM(po.poQuantity * p.avaliação) 
    END AS ValorComDesconto
FROM orders o
JOIN clients c ON o.idOrderClient = c.idClient
JOIN productOrder po ON o.idOrder = po.idPOorder
JOIN product p ON po.idPOproduct = p.idProduct
GROUP BY o.idOrder, c.Fname;
