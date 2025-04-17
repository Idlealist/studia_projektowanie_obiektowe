<?php

namespace App\Controller;

use App\Entity\Supplier;
use App\Repository\SupplierRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Serializer\SerializerInterface;

#[Route('/api/supplier')]
class SupplierApiController extends AbstractController
{
    private $entityManager;
    private $supplierRepository;
    private $serializer;

    public function __construct(EntityManagerInterface $entityManager, SupplierRepository $supplierRepository, SerializerInterface $serializer)
    {
        $this->entityManager = $entityManager;
        $this->supplierRepository = $supplierRepository;
        $this->serializer = $serializer;
    }

    #[Route('', name: 'api_supplier_index', methods: ['GET'])]
    public function index(): JsonResponse
    {
        $suppliers = $this->supplierRepository->findAll();
        $data = $this->serializer->serialize($suppliers, 'json', ['groups' => 'supplier:read']);
        return new JsonResponse($data, 200, [], true);
    }

    #[Route('', name: 'api_supplier_create', methods: ['POST'])]
    public function create(Request $request): JsonResponse
    {
        $data = json_decode($request->getContent(), true);
        $supplier = new Supplier();
        $supplier->setName($data['name'] ?? '');
        $supplier->setEmail($data['email'] ?? '');

        $this->entityManager->persist($supplier);
        $this->entityManager->flush();

        $data = $this->serializer->serialize($supplier, 'json', ['groups' => 'supplier:read']);
        return new JsonResponse($data, 201, [], true);
    }

    #[Route('/{id}', name: 'api_supplier_show', methods: ['GET'])]
    public function show(int $id): JsonResponse
    {
        $supplier = $this->supplierRepository->find($id);
        if (!$supplier) {
            return new JsonResponse(['error' => 'Supplier not found'], 404);
        }
        $data = $this->serializer->serialize($supplier, 'json', ['groups' => 'supplier:read']);
        return new JsonResponse($data, 200, [], true);
    }

    #[Route('/{id}', name: 'api_supplier_update', methods: ['PUT'])]
    public function update(int $id, Request $request): JsonResponse
    {
        $supplier = $this->supplierRepository->find($id);
        if (!$supplier) {
            return new JsonResponse(['error' => 'Supplier not found'], 404);
        }

        $data = json_decode($request->getContent(), true);
        $supplier->setName($data['name'] ?? $supplier->getName());
        $supplier->setEmail($data['email'] ?? $supplier->getEmail());

        $this->entityManager->flush();

        $data = $this->serializer->serialize($supplier, 'json', ['groups' => 'supplier:read']);
        return new JsonResponse($data, 200, [], true);
    }

    #[Route('/{id}', name: 'api_supplier_delete', methods: ['DELETE'])]
    public function delete(int $id): JsonResponse
    {
        $supplier = $this->supplierRepository->find($id);
        if (!$supplier) {
            return new JsonResponse(['error' => 'Supplier not found'], 404);
        }

        $this->entityManager->remove($supplier);
        $this->entityManager->flush();

        return new JsonResponse(null, 204);
    }
}