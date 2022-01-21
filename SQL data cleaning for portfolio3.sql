--Cleaning Data in SQL

SELECT * FROM Portfolioproject..NashvileHousing

--Standardize date format

SELECT saleDate, CONVERT(date,SaleDate) as S_date 
FROM Portfolioproject..NashvileHousing

--Update Portfolioproject..NashvileHousing
--ET SaleDate = CONVERT(date,SaleDate) 
--NOT WORKING thats why use ALTER and then update

ALTER TABLE Portfolioproject..NashvileHousing
ADD S_date_con date;

Update Portfolioproject..NashvileHousing
SET s_date_con = CONVERT(date,SaleDate)

SELECT s_date_con
FROM Portfolioproject..NashvileHousing

--POPULAR PROPERTY ADDRESS

SELECT PropertyAddress
FROM Portfolioproject..NashvileHousing
--WHERE PropertyAddress is NULL
Order By ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolioproject..NashvileHousing a
JOIN Portfolioproject..NashvileHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolioproject..NashvileHousing a
JOIN Portfolioproject..NashvileHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Breaking out individual coloumn(state,city,address)

SELECT PropertyAddress
FROM Portfolioproject..NashvileHousing

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
-- NOTE's >> (-1) we used above to remove coma after address For more LEARN remove (-1) above then we will get easily reason
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
-- NOTE's >> (+1) we used above to remove coma after address For more LEARN remove (+1) above then we will get easily reason
FROM Portfolioproject..NashvileHousing

ALTER TABLE Portfolioproject..NashvileHousing
ADD PS_Address Nvarchar(255);

Update Portfolioproject..NashvileHousing
SET PS_Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE Portfolioproject..NashvileHousing
ADD PS_City Nvarchar(255);

Update Portfolioproject..NashvileHousing
SET PS_City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT * FROM Portfolioproject..NashvileHousing


SELECT OwnerAddress FROM Portfolioproject..NashvileHousing

SELECT PARSENAME(REPLACE(OwnerAddress,',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress,',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress,',', '.') ,1)
FROM Portfolioproject..NashvileHousing

ALTER TABLE Portfolioproject..NashvileHousing
ADD OS_Address Nvarchar(255);

Update Portfolioproject..NashvileHousing
SET OS_Address = PARSENAME(REPLACE(OwnerAddress,',', '.') ,3)

ALTER TABLE Portfolioproject..NashvileHousing
ADD OS_City Nvarchar(255);

Update Portfolioproject..NashvileHousing
SET OS_City = PARSENAME(REPLACE(OwnerAddress,',', '.') ,2)

ALTER TABLE Portfolioproject..NashvileHousing
ADD OS_State Nvarchar(255);

Update Portfolioproject..NashvileHousing
SET OS_State = PARSENAME(REPLACE(OwnerAddress,',', '.') ,1)

SELECT * FROM Portfolioproject..NashvileHousing

--CHANGE Y and N to YES AND NO in 'Sold as Vacant'field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From Portfolioproject..NashvileHousing
Group By SoldAsVacant
Order By 2

SELECT SoldAsVacant,
CASE When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END
From Portfolioproject..NashvileHousing

UPDATE Portfolioproject..NashvileHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END 

	 --REMOVE Duplicates

WITH RowNumCTE AS(
SELECT *, 
   Row_Number() OVER (
   Partition By ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order By 
				   UniqueID
   ) row_num
FROM Portfolioproject..NashvileHousing
)
SELECT * 
FROM RowNumCTE
Where row_num > 1
Order By PropertyAddress

--DELETE all 104 duplicates 
WITH RowNumCTE AS(
SELECT *, 
   Row_Number() OVER (
   Partition By ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order By 
				   UniqueID
   ) row_num
FROM Portfolioproject..NashvileHousing
)
DELETE 
FROM RowNumCTE
Where row_num > 1

--DELETE all unused columns

SELECT * 
FROM Portfolioproject..NashvileHousing

ALTER TABLE Portfolioproject..NashvileHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE Portfolioproject..NashvileHousing
DROP COLUMN SaleDate