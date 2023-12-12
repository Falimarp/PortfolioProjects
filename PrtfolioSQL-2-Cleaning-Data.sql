--Cleaning Data in SQL queries

Select*
From NashvilleHousing


--Standardize Date Format

Select SaleDateConverted,Convert(Date,SaleDate)
From NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(Date,SaleDate)

ALTER TABLE Nashvillehousing
ADD SaleDateConverted  Date;

Update NashvilleHousing
SET SaleDateConverted = Convert(Date,SaleDate)

Select *
From NashvilleHousing
Where PropertyAddress is Null


--Populate Property Address data


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,ISNULL (a.propertyaddress,b.Propertyaddress)
From NashvilleHousing a
Join NashvilleHousing b
on a.parcelID = b.parcelID
And a.[uniqueID] <> b.[uniqueID]
Where a.propertyaddress is Null

Update a
SET propertyaddress = ISNULL (a.propertyaddress,b.Propertyaddress)
From NashvilleHousing a
Join NashvilleHousing b
on a.parcelID = b.parcelID
And a.[uniqueID] <> b.[uniqueID]
Where a.propertyaddress is Null

--UPDATE NashvilleHousing
--SET PropertyAddress = NULLIF(PropertyAddress, 'Null ')

--Breaking out Address into individuals Columns (address,City, State)

Select PropertyAddress
From NashvilleHousing


SELECT 
SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress)-1) as address
,SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress) +1, LEN(Propertyaddress)) as Address

From NashvilleHousing

ALTER TABLE Nashvillehousing
ADD PropertySplitAddress  Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress)-1)


ALTER TABLE Nashvillehousing
ADD PropertySplitCity  Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress) +1, LEN(Propertyaddress))


Select *
From NashvilleHousing

Select OwnerAddress
from NashvilleHousing

Select 
PARSENAME (REPLACE(OwnerAddress, ',', '.') ,3)
,PARSENAME (REPLACE(OwnerAddress, ',', '.') ,2)
,PARSENAME (REPLACE(OwnerAddress, ',', '.') ,1)
From NashvilleHousing


ALTER TABLE Nashvillehousing
ADD OwnerSplitAddress  Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME (REPLACE(OwnerAddress, ',', '.') ,3)


ALTER TABLE Nashvillehousing
ADD OwnerSplitCity  Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME (REPLACE(OwnerAddress, ',', '.') ,2)


ALTER TABLE Nashvillehousing
ADD OwnerSplitState  Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME (REPLACE(OwnerAddress, ',', '.') ,1)

Select *
From NashvilleHousing


--Change Y and N to Yes and No in "Sold as Vacant" field

Select DISTINCT(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group By SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

From NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant =
 CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


--Remove Duplicates





WITH RowNumCTE AS(

Select *,
     ROW_NUMBER() OVER (
     PARTITION BY ParcelID,
	 PropertyAddress,
	 Saleprice,
	 Saledate,
	 LegalReference
     ORDER BY 
	 UniqueID) row_num

From NashvilleHousing
--Order By parcelID

)
Delete
from RowNumCTE
Where row_num > 1
--order by Propertyaddress



--Delete Unused Columns

Select *
From Nashvillehousing

AlTER TABLE Nashvillehousing
DROP COLUMN OwnerAddress, TAXDistrict, PropertyAddress

AlTER TABLE Nashvillehousing
DROP COLUMN Saledate