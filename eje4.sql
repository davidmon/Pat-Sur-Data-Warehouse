﻿
------------------------------------------------ Punto 4 -----------------------------------------------

-- Venta vista por mes o por año, por sucursal, por región, por cliente y demás combinaciones entre las perspectivas.
SELECT T.mes, T.año, S.id_sucursal, S.descripcion as sucursal, C.id_ciudad, C.descripcion as Ciudad, CL.id_cliente, CL.nombre nombre_cliente, 
sum(V.monto_vendido) as monto_total_vendido, sum(V.cantidad_vendida) as cant_total_vendida
FROM ventas V, tiempo T, sucursal S, ciudad C, clientes CL
WHERE V.id_tiempo = T.id_tiempo and V.id_sucursal = S.id_sucursal
	and S.id_ciudad = C.id_ciudad and V.id_cliente = CL.id_cliente
GROUP BY CUBE(T.mes, T.año,
	(S.id_sucursal, S.descripcion),
	(C.id_ciudad,C.descripcion),
	(CL.id_cliente,CL.nombre)
)
	
-- Es necesario conocer también de que manera influye, en las ventas de productos, la zona geográfica en la que están ubicados los locales.
SELECT R.descripcion as Region, P.descripcion as Provincia, C.descripcion as Ciudad, sum(V.monto_vendido) as monto_total_vendido, sum(V.cantidad_vendida) as cant_total_ventida
FROM ventas V, sucursal S, ciudad C, provincia P, region R
WHERE V.id_sucursal = S.id_sucursal and S.id_ciudad = C.id_ciudad
	and C.id_provincia = P.id_provincia and P.id_region = R.id_region
GROUP BY ROLLUP (
	(R.id_region,R.descripcion),
	(P.id_provincia, P.descripcion),
	(C.id_ciudad, C.descripcion)
)

-- De cada cliente se desea conocer cuales son los que generan mayores ingresos a la cooperativa.
SELECT C.nombre as Cliente, sum(cantidad_vendida), sum(V.monto_vendido) as total_ingreso, rank() over (order by (sum(V.monto_vendido)) desc) as pos
FROM Clientes C, Ventas V
WHERE C.id_cliente = V.id_cliente
GROUP BY C.id_cliente
ORDER BY pos

-- Se necesitará hacer análisis diarios, mensuales, trimestrales y anuales.
SELECT T.año, T.trimetres, T.mes, V.fecha, sum(cantidad_vendida) as cantidad_total, sum(V.monto_vendido) as total_ingreso
FROM Ventas V, Tiempo T
WHERE V.id_tiempo = T.id_tiempo
GROUP BY ROLLUP(T.año, T.trimetres, T.mes, V.fecha)


