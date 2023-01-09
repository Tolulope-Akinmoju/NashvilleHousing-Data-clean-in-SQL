/*

Data Cleaning In SQL Queries

*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

--Standardize the SaleDate Format

--Expected new SaleDate Format
SELECT SalesDate, CONVERT(Date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing


--A new column for converted date
ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;


--Updating the  SaleDate column
UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


--Checking for top 5 SaleDateConverted Column
SELECT Top 5 SaleDateConverted
FROM PortfolioProject.dbo.NashvilleHousing





--Change Y and N to YES and NO in "Sold as Vacant" Field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END





--Populate PropertyAddress Data


--Overview of the PropertyAddress column
SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID


--Overview of the ParcelID and PropertyAddress column
SELECT ParcelID, PropertyAddress
FROM NashvilleHousing
ORDER BY ParcelID


--Populating with the use of SELF-JOIN
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing AS a
JOIN PortfolioProject.dbo.NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


Updating the missing PropertyAddress column
UPDATE a
SET PropertyAddress = ISNULL(a.propertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing AS a
JOIN PortfolioProject.dbo.NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


--Breaking out PropertyAddress into Individual Columns (Address, City)

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1 ) AS Addresss
,	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Addresss
FROM PortfolioProject.dbo.NashvilleHousing

--Create new column for Address
ALTER TABLE NashvilleHousing
ADD PropertysplitAddress Nvarchar(255)


--Create new column for City
ALTER TABLE NashvilleHousing
ADD PropertysplitCity Nvarchar(255)

--Update the new column for Address

UPDATE NashvilleHousing
SET PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


--Update the new column for City
UPDATE NashvilleHousing
SET PropertysplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1,  LEN(PropertyAddress))


--Confirm update
SELECT TOP 5 PropertysplitAddress, PropertysplitCity
FROM PortfolioProject.dbo.NashvilleHousing








--Break out OwnerAddress into Individual Columns (Address, City, State)
SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing

--Create the new column for Address
ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);


--Create the new column for City
ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);
FROM NashVileHousing


--Create the new column for State
ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);


--Update the new column for Address
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


--Update the new column for City
UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


--Update the new column for State
UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--check update
SELECT TOP 5 OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
FROM PortfolioProject.dbo.NashvilleHousing



--Remove Duplicates


WITH RowNumCTE AS(
 SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT * 
FROM RowNumCTE
WHERE ROW_NUM > 1 
--ORDER BY PropertyAddress


--Delete Unused Columns


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate
