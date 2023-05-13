SELECT *
FROM project2..housingdata

--converting SaleDate format

SELECT SaleDate, CONVERT(DATE, SaleDate)
FROM project2..housingdata


ALTER TABLE housingdata
ADD SaleDateConverted DATE

UPDATE housingdata
SET [SaleDateconverted] = CONVERT(DATE, SaleDate)

SELECT SaleDateConverted
FROM project2..housingdata

-----------------------------------------------------------------

-- Finding NULL PropertyAddress & Replacing it with PropertyAddress mentioned with same ParcelId

SELECT *
FROM project2..housingdata
WHERE PropertyAddress is NULL

SELECT *
FROM project2..housingdata
ORDER BY [ParcelID]

SELECT a.ParcelId, a.PropertyAddress, b.ParcelId, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM project2..housingdata a
JOIN project2..housingdata b
	ON a.ParcelId = b.ParcelId
	AND a.UniqueId <> b.UniqueId
WHERE a.PropertyAddress IS NULL
	AND b.PropertyAddress IS NOT NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM project2..housingdata a
JOIN project2..housingdata b
	ON a.ParcelId = b.ParcelId
	AND a.UniqueId <> b.UniqueId
WHERE a.PropertyAddress IS NULL
	AND b.PropertyAddress IS NOT NULL

------------------------------------------------------

--Check respones of SoldAsVacant, Total count and Total Yes/ No responses

SELECT DISTINCT(SoldAsVacant)
FROM project2..housingdata

SELECT COUNT(SoldAsVacant)
FROM project2..housingdata

SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM project2..housingdata
GROUP BY SoldAsVacant

--------------------------------------------------------------------

--Identifying duplicates

SELECT *
FROM project2..housingdata
	

SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY
				ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY UniqueId
				)row_num
FROM project2..housingdata
ORDER BY ParcelID


WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY
				ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY UniqueId
				)row_num
FROM project2..housingdata
)
SELECT *		-- SELECT * to see which all row will get affected, then use DROP or DELETE
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress   -- when you replace SELECT * with DELETE covert ORDER BY statement to comment by adding --














